require "salesmachine-ruby"

if __FILE__ == $0
  	# Replace this with the token from your project settings
  	TOKEN = 'xayiRjPZB13PygRX9lcbDA'
    SalesMachine.setup do |config|
		config.api_token=TOKEN
    	config.api_secret=""
    	config.hostname="api.salesmachine.io"
    end 

    SalesMachine::Track.pageview("contact_id", {:location => "/home", :user_ip => "127.0.0.1", :user_agent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.4 Safari/537.36"})



 end