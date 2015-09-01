require "salesmachine"
require 'active_support/time'


# Setting timezone for ActiveSupport::TimeWithZone to UTC
Time.zone = 'UTC'

module Salesmachine
  class Api
    API_KEY = '<api_key>'
    HOST = '127.0.0.1'
    PORT = 9000
    PATH = '/v1/batch'
    SSL = false

    CONTACT =  {
      :params => {
        :name => "John Doe",
        :email => "jdoe@acme.com",
        :age => 25
      }
    }

    TRACK = {
      :event => 'signed_up',
      :params => {
        :referrer => 'Google',
        :created =>  Time.new
      }
    }

    PAGEVIEW = {
      :event => 'pageview',
      :params => {
        :visit_ip => '46.228.47.114',
        :visit_url=> 'http://www.yahoo.com'
      }
    }


    ACCOUNT = {
      :params => {
        :name => "Acme Inc.",
        :country => "Canada"
      }
    }

    CONTACT_ID = 1234
    ACCOUNT_ID = 1234

    # Hashes sent to the client, snake_case
    module Queued
      TRACK = TRACK.merge :contact_uid => CONTACT_ID
      PAGEVIEW = PAGEVIEW.merge :contact_uid => CONTACT_ID
      CONTACT = CONTACT.merge :contact_uid => CONTACT_ID
      ACCOUNT = ACCOUNT.merge :account_uid => ACCOUNT_ID
    end


  end
end
