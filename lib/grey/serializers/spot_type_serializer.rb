# frozen_string_literal: true

module Grey
  module Serializers
    class SpotTypeSerializer < Grey::Serializers::BaseSerializer
      def api(obj)
        {
          id: obj.id,
          name: obj.name,
          slug: obj.slug,
          spots: spot_serializer.serialize(obj.spots)
        }
      end

      def nested_spot_types(obj)
        {
          name: obj.name,
          slug: obj.slug
        }
      end

      private

      def spot_serializer
        @serializer ||= SpotSerializer.new(:nested_spots)
      end
    end
  end
end
