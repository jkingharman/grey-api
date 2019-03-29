module Grey
  module Helpers
    class Hash
      def stringify_keys!
        keys.each do |key|
          self[key.to_s] = delete(key)
        end
        self
      end
    end

    def serialize_generic(serializer, type, obj)
      out = serializer.new(type).serialize(obj)

      if obj.respond_to?(:map)
        out.map{ |o| o.stringify_keys! }
      else
        out.stringify_keys!
      end
    end
  end
end
