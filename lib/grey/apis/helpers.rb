module Grey
  module Api
    module Helpers
      def authenticate!; end

      def required_params!(*keys)
        keys.each { |key| raise(ApiError::MissingParam) unless params[key] }
      end
    end
  end
end
