module Grey
  # consistent file struct require module here.
  class ApiError < StandardError
    attr_accessor :status

    def initialize(message, status=500)
      self.status = status
      super(message)
    end

    class NotFound < ApiError
      def initialize(message=nil)
        super((message || "Not found"), 404)
      end
    end
  end
end
