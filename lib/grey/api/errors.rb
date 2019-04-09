# frozen_string_literal: true

module Grey
  module Api
    class Error < StandardError
      attr_accessor :status
      attr_accessor :id

      def initialize(message, status = 500)
        self.status = status
        self.id = SecureRandom.uuid

        super(message)
      end

      class NotFound < Error
        def initialize(message = nil)
          super((message || 'Not found'), 404)
        end
      end

      class MissingParam < Error
        def initialize(message = nil)
          super((message || 'Missing Params'), 422)
        end
      end

      class Unauthorized < Error
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
end
