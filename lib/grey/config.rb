# frozen_string_literal: true

module Grey
  module Config
    extend self

    def production?
      rack_env == 'production'
    end

    def rack_env
      @rack_env ||= (env('RACK_ENV') || 'production')
    end

    def logger
      if production?
        Grey::ApiLogger.init('./grey.log', level: Logger::ERROR)
      else
        Grey::ApiLogger.init('./grey.log', level: Logger::DEBUG)
      end
    end

    private

    def env(k)
      ENV[k] unless ENV[k].blank?
    end
  end
end
