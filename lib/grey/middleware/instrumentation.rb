# frozen_string_literal: true

module Grey
  module Middleware
    # Assigns a request ID before the app runs, so the app and the log line can
    # both see it, and echoes it to the client for correlation.
    class Instrumentation
      def initialize(app)
        @app = app
      end

      def call(env)
        env["REQUEST_ID"] = SecureRandom.uuid
        status, headers, response = @app.call(env)
        headers["x-request-id"] = env["REQUEST_ID"]

        [status, headers, response]
      end
    end
  end
end
