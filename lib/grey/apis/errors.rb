# frozen_string_literal: true

module Grey
  # consistent file struct require module here.
  class ApiError < StandardError
    attr_accessor :status

    def initialize(message, status = 500)
      self.status = status
      super(message)
    end

    class NotFound < ApiError
      def initialize(message = nil)
        super((message || 'Not found'), 404)
      end
    end

    class MissingParam < ApiError
      def initialize(message = nil)
        super((message || 'Missing Params'), 422)
      end
    end

    class Unauthorized < ApiError
      def initialize(message = nil)
        super((message || 'Unauthorized'), 401)
      end
    end

    ERRORS = [
      NotFound,
      MissingParam,
      Unauthorized
    ].freeze
  end
end
