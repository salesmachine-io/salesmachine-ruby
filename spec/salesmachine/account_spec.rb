require 'spec_helper'

module Salesmachine
  class Api
    describe Client do

      describe '#account' do
        before :all do
          @client = Client.new :api_token => API_TOKEN
          @queue = @client.instance_variable_get :@queue
        end

        after :each do
          @client.flush
        end

        it 'should error without account_uid' do
          expect { @client.account }.to raise_error(ArgumentError)
        end

        it 'should not error with the required options' do
          @client.account Queued::ACCOUNT
        end

        it 'should not error with the required options as strings' do
          @client.account Utils.stringify_keys(Queued::ACCOUNT)
        end

        it 'should convert time and date traits into iso8601 format' do
          @client.account({
            :account_uid => 'acme',
            :params => {
              :time => Time.utc(2013),
              :time_with_zone =>  Time.zone.parse('2013-01-01'),
              :date_time => DateTime.new(2013,1,1),
              :date => Date.new(2013,1,1),
              :nottime => 'x'
            }
          })
          message = @queue.pop
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
