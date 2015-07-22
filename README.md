salesmachine-ruby: The Official SalesMachine Ruby library
====================================================================
salesmachine-ruby is a library for tracking events and sending **SalesMachine.IO** profile updates to **SalesMachine.IO** from your ruby applications. It's straightforward to get started sending your first events and updates:


### Installation

    With bundler:
    gem 'salesmachine-ruby', :git => 'git@github.com:salesmachine-io/salesmachine-ruby.git', :branch => 'master'


### Getting Started

You need to register in www.salesmachine.io, setup your project and issue an API token


    require 'salesmachine-ruby'

    if __FILE__ == $0
      	# Replace this with the token from your project settings
        SalesMachine.setup do |config|
            config.api_token="replace by production token"
        	config.api_secret="replace by production secret"
        end

        SalesMachine::Track.pageview("contact_id", {
        	:visit_url => "/home",
        	:visit_ip => "127.0.0.1",
        	:visit_agent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_0)"
        )

        SalesMachine::Track.event("<< contact_unique_id >>", :user_signup)

        SalesMachine::Contact.set("<< contact_unique_id >>", {
            :name => "John Doe",
            :email => "john.doe@acme.com",
            :account_id=>"<< account_unique_id ie 12345 >>",
            #.....
            }
        )

        SalesMachine::Account.set("<< account_unique_id ie 12345 >>", {
            :name => "My company",
            #.....
            }
        )

    end


The primary class you will use to track events is **SalesMachine.IO**. An instance of
SalesMachine::Track.pageview is enough to send events directly to **SalesMachine.IO**, and get you integrated
right away.

## Ruby on Rails

In Gemfile

    gem 'salesmachine-ruby', :git => 'git@github.com:salesmachine-io/salesmachine-ruby.git', :branch => 'master'

### Configuration

create a file config/initializers/salesmachine.rb

    require "salesmachine-ruby"

    SalesMachine.setup do |config|
        if Rails.env=="development"
            config.api_token="--> development token <--"
            config.api_secret="--> development secret <--"
        end
        if Rails.env=="production"
            config.api_token="--> production token <--"
            config.api_secret="--> production token <--"
        end
    end


### Additional Information

For more information please visit:

* The documentation[http://salesmachine.github.io/salesmachine-ruby/]

### Changes




