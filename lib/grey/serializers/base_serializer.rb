# frozen_string_literal: true

module Grey
  class BaseSerializer
    # Each serializer object has more than one method returning serialized
    # output for its AR model. So, when initializing a serializer, you must
    # specify the method you want to call (i.e. what type of serialized output
    # you want).
    def initialize(type)
      @type = type
    end

    def serialize(ar_obj)
      return if ar_obj.nil?

      if ar_obj.respond_to?(:map)
        ar_obj.map { |o| serialize(o) }
      else
        send(@type, ar_obj)
      end
    end
  end
end
