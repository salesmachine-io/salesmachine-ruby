require 'salesmachine/api/config'
require 'salesmachine/api/utils'
require 'salesmachine/api/response'
require 'salesmachine/api/logging'
require 'net/http'
require 'net/https'
require 'json'

module Salesmachine
  class Api
    class Request
      include Salesmachine::Api::Config::Request
      include Salesmachine::Api::Utils
      include Salesmachine::Api::Logging

      # public: Creates a new request object to send analytics batch
      #
      def initialize(options = {})
        options[:host] ||= HOST
        options[:port] ||= PORT
        options[:ssl] ||= SSL
        options[:headers] ||= HEADERS
        @path = options[:path] || PATH
        @retries = options[:retries] || RETRIES
        @backoff = options[:backoff] || BACKOFF

        http = Net::HTTP.new(options[:host], options[:port])
        http.use_ssl = options[:ssl]
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.read_timeout = 8
        http.open_timeout = 4

        @http = http
      end

      # public: Posts the write key and batch of messages to the API.
      #
      # returns - Response of the status and error if it exists
      def post(api_key, batch)
        status, error = nil, nil
        remaining_retries = @retries
        backoff = @backoff
        headers = { 'Content-Type' => 'application/json', 'accept' => 'application/json' }
        begin
          payload = batch.to_json

          request = Net::HTTP::Post.new(@path, headers)
          request.basic_auth api_key, api_key

          if self.class.stub
            status = 200
            error = nil
            logger.debug "stubbed request to #{@path}: write key = #{api_key}, payload = #{payload}"
          else
            res = @http.request(request, payload)

            status = res.code.to_i
            unless status == 200 or status == 201
              body = JSON.parse(res.body)
              error = body["error"]
            end
          end
        rescue Exception => e
          unless (remaining_retries -= 1).zero?
            sleep(backoff)
            retry
          end

          logger.error e.message
          e.backtrace.each { |line| logger.error line }
          status = -1
          error = "Connection error: #{e}"
        end

        Response.new status, error
      end

      class << self
        attr_accessor :stub

        def stub
          @stub || ENV['STUB']
        end
      end
    end
  end
end
