require 'spec_helper'
require 'salesmachine-ruby.rb'
require 'time'


describe SalesMachine::Track do
	before(:each) do
    	SalesMachine.setup do |config|
			config.api_token="yaxiRjPZB13PygRX9lsdcz"
    		config.api_secret="xayiRjPZB13PygRX9lcbDA"

    		config.hostname="127.0.0.1:9000"
    		config.protocol="http"
    	end
	end

	it 'should send tracker data' do
		SalesMachine::Track.pageview("test@acme.com", {:visit_url => "/home", :visit_ip => "127.0.0.1", :visit_agent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.4 Safari/537.36"})
	end
end