# frozen_string_literal: true

module Grey
  module Config
    class ConfigError < StandardError; end
    extend self

    def database_url
      env!('DATABASE_URL')
    end

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
        level: production_env? ? Logger::ERROR : Logger::DEBUG
      )
    end

    private

    def env!(k)
      env(k) || raise(ConfigError, "#{k} not found in environment")
    end

    def env(k)
      ENV[k] unless ENV[k].blank?
    end
  end
end
