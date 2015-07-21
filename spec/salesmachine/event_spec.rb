require 'spec_helper'

module Salesmachine
  class Api
    describe Client do

      describe '#track' do
        before(:all) do
          @client = Client.new :api_token => API_TOKEN
          @queue = @client.instance_variable_get :@queue
        end

        after :each do
          @client.flush
        end

        it 'should error without an event' do
          expect { @client.track(:contact_uid => 'user') }.to raise_error(ArgumentError)
        end

        it 'should error without a contact_uid' do
          expect { @client.track(:event_uid => 'event') }.to raise_error(ArgumentError)
        end

        it 'should error if params is not a hash' do
          expect {
            @client.track({
              :contact_uid => CONTACT_UID,
              :event_uid => 'event',
              :params => [1,2,3]
            })
          }.to raise_error(ArgumentError)
        end

        it 'should use the timestamp given' do
          time = Time.parse("1990-07-16 13:30:00.123 UTC")

          @client.track({
            :contact_uid => CONTACT_UID,
            :event_uid => 'testing the timestamp',
            :created_at => time,
            :params => {
              :account_uid => ACCOUNT_UID
            }
          })

          Time.parse(msg[:created_at]).should == time
        end

        it 'should not error with the required options' do
          @client.track Queued::TRACK
        end

        it 'should not error when given string keys' do
          @client.track Utils.stringify_keys(Queued::TRACK)
        end

        it 'should convert time and date traits into iso8601 format' do
          @client.track({
            :contact_uid => CONTACT_UID,
            :event_uid => 'event',
            :params => {
              :time => Time.utc(2013),
              :time_with_zone =>  Time.zone.parse('2013-01-01'),
              :date_time => DateTime.new(2013,1,1),
              :date => Date.new(2013,1,1),
              :nottime => 'x',
              :account_uid => ACCOUNT_UID
            }
          })
          message[:params][:time].should == '2013-01-01T00:00:00.000Z'
          message[:params][:time_with_zone].should == '2013-01-01T00:00:00.000Z'
          message[:params][:date_time].should == '2013-01-01T00:00:00.000Z'
          message[:params][:date].should == '2013-01-01'
          message[:params][:nottime].should == 'x'
        end
      end

    end
  end
end
