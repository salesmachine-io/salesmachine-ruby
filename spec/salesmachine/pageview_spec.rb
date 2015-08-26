require 'spec_helper'

module Salesmachine
  class Api
    describe Client do

      describe '#pageview' do
        before :all do
          @client = Client.new :api_key => API_KEY, :host => HOST, :port => PORT,
                                :path => PATH, :ssl => false
        end

        it 'should error without contact_uid' do
          expect { @client.pageview   }.to raise_error(ArgumentError)
        end

        it 'should not error with the required options' do
          @client.pageview Queued::PAGEVIEW
        end

        it 'should not error with the required options as strings' do
          @client.pageview Utils.stringify_keys(Queued::PAGEVIEW)
          @client.flush
        end
      end
    end
  end
end
