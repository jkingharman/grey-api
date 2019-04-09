# frozen_string_literal: true

module Grey
  module Middleware
  # Emits a single log line that displays as much relevant info for a request as possible.
    class ApiLogLine
      LOGFIELDS = %i[
        error_class
        error_message
        error_id
        request_id
        request_method
        request_ip
        request_path
        request_user_agent
        response_length
        response_status
        timing_total_elapsed
      ].freeze

      # Nested model, responsible for log line construction.
      class LogLine
        def self.create_log_field(name)
          unless name.is_a?(Symbol)
            raise ArgumentError, 'Expected first argument to be a symbol'
          end

          define_method(:"#{name}=") do |val|
            set_field(name, val)
          end
        end

        def set_field(name, val)
          @fields ||= {}
          @fields[name] = val
        end

        def to_h
          @fields
        end
      end

      LOGFIELDS.each { |field| LogLine.create_log_field(field) }

      def initialize(app, emitter:)
        @app = app
        @emitter = emitter
      end

      def call(env)
        begin
          start = Time.now
          status, headers, response = @app.call(env)
        ensure
          begin
            line = LogLine.new

            if error = env['grey.error']
              line.error_class = error.class.name
              line.error_message = error.message

              line.error_id = error.id.to_s if error.is_a?(Grey::ApiError)
            end

            # request info
            request = Rack::Request.new(env)
            line.request_id = env['REQUEST_ID']
            line.request_ip = request.ip
            line.request_method = request.request_method
            line.request_path = request.path_info
            line.request_user_agent = request.user_agent

            # response info
            if length = headers['Content-Length']
              line.response_length = length.to_i
            end
            line.response_status = status

            # timing info
            line.timing_total_elapsed = (Time.now - start).to_f

            @emitter.call(line.to_h)
          rescue StandardError => e
            env["rack.errors"].write "ApiLogLine failed to emit log"
          end
        end

        [status, headers, response]
      end
    end
  end
end
