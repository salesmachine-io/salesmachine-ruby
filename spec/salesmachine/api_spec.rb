require 'spec_helper'

module Salesmachine
  class Api
    describe Client do

      describe '#initialize' do
        it 'should error if no api_key is supplied' do
          expect { Client.new }.to raise_error(ArgumentError)
        end

        it 'should not error if a api_key is supplied' do
          Client.new :api_key => API_KEY
        end

        it 'should not error if a api_key is supplied as a string' do
          Client.new 'api_key' => API_KEY
        end
      end
    end
  end
end
