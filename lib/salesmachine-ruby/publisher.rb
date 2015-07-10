require 'base64'
require 'net/https'
require 'json'

module SalesMachine
  class ConnectionError < IOError
  end

  class Publisher
    def initialize()
      @api_token = SalesMachine.api_token
      @api_secret = SalesMachine.api_secret
      @protocol = SalesMachine.protocol
      @protocol = "https" unless ["http","https"].include?(@protocol)
    end

    def base_url(endpoint)
      endpoint = endpoint.to_sym

      base_url = "#{@protocol}://#{SalesMachine.hostname}/v1"
      endpoints = {
        :tracker => "#{base_url}/track/event",
        :contact => "#{base_url}/contact",
        :element => "#{base_url}/element",
        :email => "#{base_url}/email",
        :product => "#{base_url}/product",
        :account => "#{base_url}/account"
      }[endpoint]
    end

    def client(uri)
      net = Net::HTTP.new(uri.host, uri.port)
      if uri.is_a?(URI::HTTPS)
        net.use_ssl = true
        net.verify_mode = OpenSSL::SSL::VERIFY_NONE
        #net.verify_mode = OpenSSL::SSL::VERIFY_PEER
        #net.ca_file = File.join(File.dirname(__FILE__), '../data/cacert.pem')
      end
      net.read_timeout = 30
      net.open_timeout = 3
      net
    end


    def decode(content_encoding, body)
      return body if (!body) || body.empty? || content_encoding != 'gzip'
      Zlib::GzipReader.new(StringIO.new(body)).read
    end

    def raise_errors_on_failure(res)
      if res.code.to_i.eql?(404)
        raise SalesMachine::ResourceNotFound
      elsif res.code.to_i.eql?(401)
        raise SalesMachine::AuthenticationError
      elsif res.code.to_i.eql?(500)
        raise SalesMachine::ServerError
      elsif res.code.to_i.eql?(502)
        raise SalesMachine::BadGatewayError
      elsif res.code.to_i.eql?(503)
        raise SalesMachine::ServiceUnavailableError
      end
    end

    def track(contact_uid, event_uid, params={})
      message = { :contact_uid => contact_uid, :event_uid => event_uid, :created_at => Time.now.to_i, :params => params }
      post(:tracker, message)
    end

    def set(endpoint, unique_id, params={})
      api_key = SalesMachine.api_token
      api_secret = SalesMachine.api_secret
      message =  {:unique_id=>unique_id,:created_at=>Time.now.to_i,:params=>params}
      post(endpoint, message)
    end


    def post(endpoint, data)
      data_encoded = Base64.encode64(data.to_json).gsub("\n", '')

      message = {}
      message[:api_token] = @api_token
      message[:encode] = :base64
      message[:data] = data_encoded.to_json

      begin
      uri = URI.parse(base_url(endpoint))

      client = client(uri)

      request = Net::HTTP::Post.new(uri.request_uri)
      request.basic_auth(CGI.unescape(@api_token), CGI.unescape(@api_secret))
      request.add_field('Accept', 'application/json')
      request.add_field('AcceptEncoding', 'gzip, deflate')

      request.set_form_data(message)
      response = client.request(request)

      succeeded = false
      if ['200','201'].include?(response.code)
        result = JSON.load(response.body) rescue {}
        succeeded = true #result['status'] == 1
      end

      if succeeded
        return true
      else
        error = "Could not write to SalesMachine, server responded with #{response.code} returning: '#{response.body}'"
        puts error
        return error
      end

      rescue Exception => e
        return e
      end
    end
  end
end

