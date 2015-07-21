require "salesmachine"
require 'wrong'
require 'active_support/time'

include Wrong

# Setting timezone for ActiveSupport::TimeWithZone to UTC
Time.zone = 'UTC'

module Salesmachine
  class Api
    API_TOKEN = '<api_token>'
    API_SECRET = '<api_secret>'

    CONTACT = {
      :params => {
        :name => "John Doe",
        :email => "jdoe@acme.com",
        :age => 25
      }
    }

    TRACK = {
      :event_uid => 'signed_up',
      :params => {
        :referrer => 'Google',
        :created =>  Time.new,
      }
    }

    PAGEVIEW = {
      :event_uid => 'pageview',
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

    EMAIL = {
      :email => "My Email title",
      :params => {
        :type => "Newsletter email"
      }
    }

    CONTACT_UID = 1234
    ACCOUNT_UID = 1234

    # Hashes sent to the client, snake_case
    module Queued
      TRACK = TRACK.merge :contact_uid => CONTACT_UID
      TRACK[:params] = TRACK[:params].merge :account_uid => ACCOUNT_UID

      PAGEVIEW = PAGEVIEW.merge :contact_uid => CONTACT_UID
      PAGEVIEW[:params] = PAGEVIEW[:params].merge :account_uid => ACCOUNT_UID

      EMAIL = EMAIL.merge :contact_uid => CONTACT_UID
      EMAIL[:params] = EMAIL[:params].merge :account_uid => ACCOUNT_UID

      CONTACT = CONTACT.merge :contact_uid => CONTACT_UID
      CONTACT[:params] = CONTACT[:params].merge :account_uid => ACCOUNT_UID

      ACCOUNT = ACCOUNT.merge :account_uid => ACCOUNT_UID
    end


  end
end
