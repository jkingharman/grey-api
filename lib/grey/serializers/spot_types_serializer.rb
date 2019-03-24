# frozen_string_literal: true

module Grey
  class SpotTypesSerializer < Grey::BaseSerializer
    def api(obj)
      {
        id: obj.id,
        name: obj.name,
        slug: obj.slug,
        created_at: obj.created_at,
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
      @serializer ||= SpotsSerializer.new(:nested_spots)
    end
  end
end
