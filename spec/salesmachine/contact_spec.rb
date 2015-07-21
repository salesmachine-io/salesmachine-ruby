require 'spec_helper'

module Salesmachine
  class Api
    describe Client do

      describe '#contact' do
        before(:all) do
          @client = Client.new :api_token => API_TOKEN
          @queue = @client.instance_variable_get :@queue
        end

        after :each do
          @client.flush
        end

        it 'should error without any contact id' do
          expect { @client.contact({}) }.to raise_error(ArgumentError)
        end

        it 'should not error with the required options' do
          @client.contact Queued::CONTACT
        end

        it 'should not error with the required options as strings' do
          @client.contact Utils.stringify_keys(Queued::CONTACT)
        end

        it 'should convert time and date params into iso8601 format' do
          @client.contact({
            :contact_uid => CONTACT_UID,
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
