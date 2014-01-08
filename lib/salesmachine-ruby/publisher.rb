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

		def base_url(event)
			event = event.to_sym

      		endpoints = {
        		:tracker => "#{@protocol}://#{SalesMachine.hostname}/v1/track/event",
        		:contact => "#{@protocol}://#{SalesMachine.hostname}/v1/contact",
        		:user => "#{@protocol}://#{SalesMachine.hostname}/v1/user",
        		:customer => "#{@protocol}://#{SalesMachine.hostname}/v1/customer",
        		:account => "#{@protocol}://#{SalesMachine.hostname}/v1/account",
        		:pageview => "#{@protocol}://#{SalesMachine.hostname}/v1/pageview",
        		:email => "#{@protocol}://#{SalesMachine.hostname}/v1/email"
      		}[ event ]
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


		def publish(endpoint,event,unique_id,params={})
			message = {  :unique_id=>unique_id,:event=>event,:params=>params}

			post(endpoint, message)
    	end

		def track(event,unique_id,params={})
			message = {  :unique_id=>unique_id,:event=>event,:params=>params}

			post(:tracker, message)
    	end


		def set(endpoint,unique_id,params={})
			api_key = SalesMachine.api_token
			api_secret = SalesMachine.api_secret

			message =  {:unique_id=>unique_id,:params=>params} 

			post(endpoint, message)
    	end


    	def post(endpoint,data)
    		data_encoded= Base64.encode64(data.to_json).gsub("\n", '')     			

    		message={}
    		message[:api_token]=@api_token
    		message[:encode]=:base64
    		message[:data]=data_encoded.to_json

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
					error="Could not write to SalesMachine, server responded with #{response.code} returning: '#{response.body}'"
					puts error
					return error
				end
			rescue Exception => e
				return e
			end

    	end

    end
end

