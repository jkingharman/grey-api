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
      get do
        serialize(Models::SpotType.all)
      end

      get ":id" do
        spot_type = Models::SpotType.find_by(id: params[:id]) || raise(ApiError::NotFound)
        serialize(spot_type)
      end

      post do
        authorize!
        required_params!(:spot_type)
        spot_type = Models::SpotType.create!(
          name: params[:spot_type][:name], slug: params[:spot_type][:slug],
        )
        serialize(spot_type)
      end

      put ":id" do
        authorize!
        required_params!(:spot_type)
        spot_type = Models::SpotType.find_by(id: params[:id]) || raise(ApiError::NotFound)
        spot_type.update(
          name: params[:spot_type][:name], slug: params[:spot_type][:slug]
        )
        serialize(spot_type)
      end

      delete ":id" do
        authorize!
        spot_type = Models::SpotType.find_by(id: params[:id]) || raise(ApiError::NotFound)
        spot_type.destroy
        {}.to_json
      end
    end
  end
end
