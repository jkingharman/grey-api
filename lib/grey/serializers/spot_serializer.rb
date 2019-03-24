# frozen_string_literal: true

module Grey
  class SpotSerializer < Grey::BaseSerializer
    def api(obj)
      {
        id: obj.id,
        name: obj.name,
        slug: obj.slug,
        created_at: obj.created_at,
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
