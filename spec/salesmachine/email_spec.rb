require 'spec_helper'

module Salesmachine
  class Api
    describe Client do

      describe '#email' do
        before(:all) do
          @client = Client.new :api_token => API_TOKEN
          @queue = @client.instance_variable_get :@queue
        end

        after :each do
          @client.flush
        end

        it 'should error without an email' do
          expect { @client.email(:contact_uid => 'user') }.to raise_error(ArgumentError)
        end

        it 'should error without a contact_uid' do
          expect { @client.email(:email => 'email_uid') }.to raise_error(ArgumentError)
        end

        it 'should error if params is not a hash' do
          expect {
            @client.email({
              :contact_uid => CONTACT_UID,
              :email => 'email',
              :params => [1,2,3]
            })
          }.to raise_error(ArgumentError)
        end

        it 'should not error with the required options' do
          @client.email Queued::EMAIL
        end

        it 'should not error when given string keys' do
          @client.email Utils.stringify_keys(Queued::EMAIL)
        end

        it 'should use the timestamp given' do
          time = Time.parse("1990-07-16 13:30:00.123 UTC")

          msg = @client.email({
            :contact_uid => CONTACT_UID,
            :email => 'email',
            :created_at => time
          })

          Time.parse(msg[:created_at]).should == time
        end

        it 'should flush the queue after an email has been added' do
          @client.track({
            :contact_uid => CONTACT_UID,
            :event_uid => 'testing the timestamp'
          })

          @client.email({
            :contact_uid => CONTACT_UID,
            :email => 'email'
          })

          @client.queued_nb.should == 0
        end

      end
    end
  end
end