module Grey
  class ApiError < StandardError
    def initialize(message, status=500)
      @status = status
      super(message)
    end

    class NotFound < ApiError
      def initialize(message=nil)
        super((message || "Not found"), 404)
      end
    end
  end
end
