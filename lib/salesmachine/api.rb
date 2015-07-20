require 'salesmachine/api/version'

require 'salesmachine/api/config'
require 'salesmachine/api/utils'
require 'salesmachine/api/client'
require 'salesmachine/api/worker'
require 'salesmachine/api/request'
require 'salesmachine/api/response'
require 'salesmachine/api/logging'

module Salesmachine
  class Api
    def initialize options = {}
      Request.stub = options[:stub]
      @client = Salesmachine::Api::Client.new options
    end

    def method_missing message, *args, &block
      if @client.respond_to? message
        @client.send message, *args, &block
      else
        super
      end
    end

    def respond_to? method_name, include_private = false
      @client.respond_to?(method_name) || super
    end

    include Logging
  end
end
