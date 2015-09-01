module Salesmachine
  class Api
    module Config
      module Request
        HOST = 'api.salesmachine.io'
        PORT = 443
        PATH = '/v1/batch'
        SSL = true
        HEADERS = { :accept => 'application/json' }
        RETRIES = 4
        BACKOFF = 30.0
      end

      module Queue
        BATCH_SIZE = 100
        MAX_SIZE = 10000
      end
    end
  end
end
