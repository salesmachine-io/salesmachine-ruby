require 'thread'
require 'time'
require 'salesmachine/api/utils'
require 'salesmachine/api/worker'
require 'salesmachine/api/config'

module Salesmachine
  class Api
    class Client
      include Salesmachine::Api::Utils

      # public: Creates a new client
      #
      # attrs - Hash
      #           :api_key         - String of your project's api_key
      #           :max_queue_size - Fixnum of the max calls to remain queued (optional)
      #           :on_error       - Proc which handles error calls from the API
      def initialize attrs = {}
        symbolize_keys! attrs

        @queue = Queue.new
        @api_key = attrs[:api_key]
        @max_queue_size = attrs[:max_queue_size] || Config::Queue::MAX_SIZE
        @options = attrs
        @worker_mutex = Mutex.new
        @worker = Worker.new @queue, @api_key, @options

        check_api_key!

        at_exit { @worker_thread && @worker_thread[:should_exit] = true }
      end

      # public: Synchronously waits until the worker has flushed the queue.
      #         Use only for scripts which are not long-running, and will
      #         specifically exit
      #
      def flush
        while !@queue.empty? || @worker.is_requesting?
          ensure_worker_running
          sleep(0.1)
        end
      end

      # public: Tracks an event
      #
      # attrs - Hash
      def track attrs
        symbolize_keys! attrs
        check_contact_id! attrs

        event = attrs[:event]
        params = attrs[:params] || {}
        created_at = attrs[:created_at] || Time.new

        check_timestamp! created_at

        if event.nil? || event.empty?
          fail ArgumentError, 'Must supply event as a non-empty string'
        end

        fail ArgumentError, 'Params must be a Hash' unless params.is_a? Hash
        isoify_dates! params

        enqueue({
          :event => event,
          :contact_uid => attrs[:contact_uid],
          :params => params,
          :created_at => datetime_in_iso8601(created_at),
          :method => 'event'
        })
      end

      # public: Send an email
      #
      # attrs - Hash
      def email attrs
        symbolize_keys! attrs
        check_contact_id! attrs

        email = attrs[:email]
        params = attrs[:params] || {}
        created_at = attrs[:created_at] || Time.new

        check_timestamp! created_at

        if email.nil? || evemailent.empty?
          fail ArgumentError, 'Must supply email template as a non-empty string'
        end

        fail ArgumentError, 'Params must be a Hash' unless params.is_a? Hash
        isoify_dates! params

        enqueue({
          :event => event,
          :contact_uid => attrs[:contact_uid],
          :params => params,
          :created_at => datetime_in_iso8601(created_at),
          :method => 'email'
        })
      end


      def contact attrs
        symbolize_keys! attrs
        check_contact_id! attrs

        params = attrs[:params] || {}
        created_at = attrs[:created_at] || Time.new

        check_timestamp! created_at

        fail ArgumentError, 'Must supply params as a hash' unless params.is_a? Hash
        isoify_dates! params

        enqueue({
          :contact_uid => attrs[:contact_uid],
          :params => params,
          :created_at => datetime_in_iso8601(created_at),
          :method => 'contact'
        })
      end


      def account(attrs)
        symbolize_keys! attrs
        fail ArgumentError, 'Must supply a contact_uid' unless attrs[:account_uid]

        account_uid = attrs[:account_uid]
        params = attrs[:params] || {}
        created_at = attrs[:created_at] || Time.new

        fail ArgumentError, 'Params must be a hash' unless params.is_a? Hash
        isoify_dates! params

        check_timestamp! created_at

        enqueue({
          :account_uid => account_uid,
          :params => params,
          :created_at => datetime_in_iso8601(created_at),
          :method => 'account'
        })
      end

      def pageview(attrs)
        symbolize_keys! attrs
        check_contact_id! attrs

        params = attrs[:params] || {}
        created_at = attrs[:created_at] || Time.new

        fail ArgumentError, '.params must be a hash' unless params.is_a? Hash
        isoify_dates! params

        check_timestamp! created_at

        enqueue({
          :contact_uid => attrs[:contact_uid],
          :event => "pageview",
          :params => attrs[:params],
          :created_at => datetime_in_iso8601(created_at),
          :method => 'pageview'
        })
      end

      # public: Returns the number of queued messages
      #
      # returns Fixnum of messages in the queue
      def queued_messages
        @queue.length
      end

      private

      # private: Enqueues the action.
      #
      # returns Boolean of whether the item was added to the queue.
      def enqueue(action)
        # add our request id for tracing purposes
        action[:messageId] = uid
        unless queue_full = @queue.length >= @max_queue_size
          ensure_worker_running
          @queue << action
        end
        !queue_full
      end

      # private: Ensures that a string is non-empty
      #
      # obj    - String|Number that must be non-blank
      # name   - Name of the validated value
      #
      def check_presence!(obj, name)
        if obj.nil? || (obj.is_a?(String) && obj.empty?)
          fail ArgumentError, "#{name} must be given"
        end
      end

      # private: Adds contextual information to the call
      #
      # context - Hash of call context
      def add_context(context)
        context[:library] =  { :name => "salesmachine-ruby", :version => Salesmachine::Api::VERSION.to_s }
      end

      # private: Checks that the api_key is properly initialized
      def check_api_key!
        fail ArgumentError, 'Api key must be initialized' if @api_key.nil?
      end

      # private: Checks the timstamp option to make sure it is a Time.
      def check_timestamp!(timestamp)
        fail ArgumentError, 'Timestamp must be a Time' unless timestamp.is_a? Time
      end

      def check_contact_id! attrs
        fail ArgumentError, 'Must supply a contact_uid' unless attrs[:contact_uid]
      end

      def ensure_worker_running
        return if worker_running?
        @worker_mutex.synchronize do
          return if worker_running?
          @worker_thread = Thread.new do
            @worker.run
          end
        end
      end

      def worker_running?
        @worker_thread && @worker_thread.alive?
      end
    end
  end
end
