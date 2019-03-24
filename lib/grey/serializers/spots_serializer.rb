module Grey
  class SpotsSerializer < Grey::BaseSerializer
    def api(obj)
      {
        id: obj.id,
        name: obj.name,
        slug: obj.slug,
        created_at: obj.created_at,
        spot_type: spot_types_serializer.serialize(obj.spot_type)
      }.to_json
    end

    def nested_spots(obj)
      {
        name: obj.name,
        slug: obj.slug
      }.to_json
    end

    private

    def spot_types_serializer
      @serializer ||= SpotTypesSerializer.new(:nested_spot_types)
    end
  end
end
