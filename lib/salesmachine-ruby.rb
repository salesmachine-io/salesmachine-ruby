require 'salesmachine-ruby/publisher.rb'
require 'salesmachine-ruby/version.rb'
require 'salesmachine-ruby/contact.rb'
require 'salesmachine-ruby/user.rb'
require 'salesmachine-ruby/element.rb'
require 'salesmachine-ruby/track.rb'
require 'salesmachine-ruby/email.rb'
require 'salesmachine-ruby/product.rb'

module SalesMachine
	@@hostname = "api.salemachine.io"
	@@protocol = "https"
	@@api_token = nil
	@@api_secret = nil

	def self.protocol
    	@@protocol
  	end
	def self.protocol=(protocol)
    	@@protocol = protocol
	end

	def self.api_token
    	@@api_token
	end
	def self.api_token=(api_token)
		@@api_token = api_token
	end

	def self.api_secret
    	@@api_secret
	end
	def self.api_secret=(api_secret)
    	@@api_secret = api_secret
	end

	def self.hostname
    	@@hostname
	end
	def self.hostname=(hostname)
    	@@hostname = hostname
	end

	def self.setup
		yield self
	end

	# Raised when the credentials you provide don't match a valid account on SalesMachine.
	# Check that you have set <b>Intercom.app_id=</b> and <b>Intercom.api_key=</b> correctly.
	class AuthenticationError < StandardError;
	end

	# Raised when something does wrong on within the SalesMachine API service.
	class ServerError < StandardError;
	end

	# Raised when we have bad gateway errors.
	class BadGatewayError < StandardError;
	end

	# Raised when we reach socket connect timeout
	class ServiceUnavailableError < StandardError;
	end

	# Raised when requesting resources on behalf of a user that doesn't exist in your application on SalesMachine.
	class ResourceNotFound < StandardError;
	end

	

end