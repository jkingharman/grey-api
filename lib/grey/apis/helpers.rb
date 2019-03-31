module Grey
  module Api
    module Helpers
      # for dev/testing only, obvs
      def debug
        require "pry"
        binding.pry
      end

      def authorize!
        raise(ApiError::Unauthorized) unless authorized?
      end

      def required_params!(*keys)
        keys.each { |key| raise(ApiError::MissingParam) unless params[key] }
      end

      private

      def authorized?
        @auth ||= Rack::Auth::Basic::Request.new(request.env)
        @auth.provided? && @auth.basic? && @auth.credentials == ["user", "secret"]
      end
    end
  end
end
