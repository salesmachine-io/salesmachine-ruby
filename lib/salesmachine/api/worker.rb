require 'salesmachine/api/utils'
require 'salesmachine/api/config'
require 'salesmachine/api/request'

module Salesmachine
  class Api
    class Worker
      include Salesmachine::Api::Utils
      include Salesmachine::Api::Config

      # public: Creates a new worker
      #
      # The worker continuously takes messages off the queue
      # and makes requests to the salesmachine.io api
      #
      # queue   - Queue synchronized between client and worker
      # api_key  - String of the application's Api key
      # options - Hash of worker options
      #           batch_size - Fixnum of how many items to send in a batch
      #           on_error   - Proc of what to do on an error
      #
      def initialize(queue, api_key, options = {})
        symbolize_keys! options
        @queue = queue
        @api_key = api_key
        @batch_size = options[:batch_size] || Queue::BATCH_SIZE
        @on_error = options[:on_error] || Proc.new { |status, error| }
        @batch = []
        @lock = Mutex.new
      end

      # public: Continuously runs the loop to check for new events
      #
      def run
        until Thread.current[:should_exit]
          return if @queue.empty?

          @lock.synchronize do
            until @batch.length >= @batch_size || @queue.empty?
              @batch << @queue.pop
            end
          end

          res = Request.new.post @api_key, @batch

          @lock.synchronize { @batch.clear }

          @on_error.call res.status, res.error unless res.status == 200
        end
      end

      # public: Check whether we have outstanding requests.
      #
      def is_requesting?
        @lock.synchronize { !@batch.empty? }
      end
    end
  end
end
