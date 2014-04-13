salesmachine-ruby: The Official SalesMachine Ruby library
====================================================================
salesmachine-ruby is a library for tracking events and sending **SalesMachine.IO** profile updates to **SalesMachine.IO** from your ruby applications. It's straightforward to get started sending your first events and updates:


### Installation

    gem install salesmachine-ruby

### Getting Started

You need to register in www.salesmachine.io, setup your project and issue an API token


    require 'salesmachine-ruby'

    if __FILE__ == $0
  	# Replace this with the token from your project settings
  	TOKEN = 'your token here'
    SalesMachine.setup do |config|
	config.api_token=TOKEN
    	config.api_secret=""
    	config.hostname="my.salesmachine.io"
    	config.protocol="http"
    end 


    SalesMachine::Track.pageview("contact_id", {
    	:visit_url => "/home", 
    	:visit_ip => "127.0.0.1", 
    	:visit_agent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_0)"

    )

    SalesMachine::Track.event("<< contact_unique_id >>", "New Signup")
    
    SalesMachine::Contact.set("<< contact_unique_id >>", {
    	:name => "John Doe", 
    	:company => "Acme", 
   	:email => "john.doe@acme.com",
	#.....
    	}
    )


    end


The primary class you will use to track events is **SalesMachine.IO**. An instance of
SalesMachine::Track.pageview is enough to send events directly to **SalesMachine.IO**, and get you integrated
right away.

### Additional Information

For more information please visit:

* The documentation[http://salesmachine.github.io/salesmachine-ruby/]

### Changes




