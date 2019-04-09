# frozen_string_literal: true

module Grey
  module Serializers
    class SpotSerializer < Grey::Serializers::BaseSerializer
      def api(obj)
        {
          id: obj.id,
          name: obj.name,
          slug: obj.slug,
          spot_type: spot_types_serializer.serialize(obj.spot_type)
        }
      end

      def nested_spots(obj)
        {
          name: obj.name,
          slug: obj.slug
        }
      end

      private

      def spot_types_serializer
        @serializer ||= SpotTypeSerializer.new(:nested_spot_types)
      end
    end
  end
end
