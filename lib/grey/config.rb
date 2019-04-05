# frozen_string_literal: true

module Grey
  module Config
    extend self

    def production_env?
      rack_env == 'production'
    end

    def test_env?
      rack_env == 'test'
    end

    def rack_env
      @rack_env ||= (env('RACK_ENV') || 'production')
    end

    def logger
        Grey::ApiLogger.init(
          './log/grey.log',
          "#{production_env? ? Logger::Error : Logger::Debug}"
        )
    end

    private

    def env(k)
      ENV[k] unless ENV[k].blank?
    end
  end
end
