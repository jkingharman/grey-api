# frozen_string_literal: true

module Grey
  module Api
    class SpotTypeAPI < Grape::API
      version 'v0', using: :path

      format :json
      default_error_status :json

      helpers do
        include Api::Helpers

        def serializer
          @serializer ||= Grey::Serializers::SpotTypeSerializer.new(:api)
        end

        def serialize(obj)
          serializer.serialize(obj)
        end
      end

      resource :spot_types do
        get do
          serialize(Models::SpotType.all)
        end

        get 'search' do
          spots = Models::SpotType.search_by_name(params[:query])
          serialize(spots)
        end

        get ':id' do
          spot_type = Models::SpotType.find_by(id: params[:id]) || raise(Error::NotFound)
          serialize(spot_type)
        end
      end
    end
  end
end
