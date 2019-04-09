# frozen_string_literal: true

module Grey
  module Api
    module Helpers
      def debug
        require 'pry'
        binding.pry
      end

      def authorize!
        raise(Error::Unauthorized) unless authorized?
      end

      def required_params!(*keys)
        keys.each { |key| raise(Error::MissingParam) unless params[key] }
      end

      private

      def authorized?
        @auth ||= Rack::Auth::Basic::Request.new(request.env)
        @auth.provided? && @auth.basic? && @auth.credentials == ['user', Grey::Config.api_key]
      end
    end
  end
end
