require 'spec_helper'

module Salesmachine
  class Api
    describe Client do

      describe '#initialize' do
        it 'should error if no api_token is supplied' do
          expect { Client.new }.to raise_error(ArgumentError)
        end

        it 'should not error if a api_token is supplied' do
          Client.new :api_token => API_TOKEN
        end

        it 'should not error if a api_token is supplied as a string' do
          Client.new 'api_token' => API_TOKEN
        end
      end
    end
  end
end
