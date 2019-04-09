# frozen_string_literal: true

module Grey
  class Instrumentation
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, response = @app.call(env)
      env['REQUEST_ID'] = SecureRandom.uuid

      [status, headers, response]
    end
  end
end
