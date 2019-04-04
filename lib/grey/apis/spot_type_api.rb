# frozen_string_literal: true

module Grey
  # consistent file struct require module here.
  class SpotTypeAPI < Grape::API
    version 'v0', using: :path

    format :json
    default_error_status :json

    helpers do
      include Api::Helpers

      def serializer
        @serializer ||= SpotTypeSerializer.new(:api)
      end

      def serialize(obj)
        serializer.serialize(obj)
      end
    end

    resource :spot_types do
      after { Grey::ApiLogger.log(env, status) }

      get do
        serialize(Models::SpotType.all)
      end

      get ':id' do
        spot_type = Models::SpotType.find_by(id: params[:id]) || raise(ApiError::NotFound)
        serialize(spot_type)
      end
    end
  end
end
