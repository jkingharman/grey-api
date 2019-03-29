# frozen_string_literal: true

module Grey
  # consistent file struct require module here.
  class SpotAPI < Grape::API
    version 'v0', using: :path

    format :json
    default_error_status :json

    helpers do
      include Api::Helpers

      def serializer
        @serializer ||= SpotSerializer.new(:api)
      end

      def serialize(obj)
        serializer.serialize(obj)
      end
    end

    resource :spots do
      get do
        serialize(Models::Spot.all)
      end

      get ":id" do
        spot = Models::Spot.find_by(id: params[:id]) || raise(ApiError::NotFound)
        serialize(spot)
      end

      params do
        requires :spot, type: Hash do
          requires :name, type: String
          requires :slug, type: String
        end
      end

      post do
        authenticate!
        spot = Models::Spot.create!(
          name: params[:spot][:name], slug: params[:spot][:slug]
        )
        serialize(spot)
      end

      params do
        requires :spot, type: Hash do
          requires :name, type: String
          requires :slug, type: String
        end
      end

      put ":id" do
        authenticate!

        spot = Models::Spot.find_by(id: params[:id]) || raise(ApiError::NotFound)
        spot.update(
          name: params[:spot][:name], slug: params[:spot][:slug]
        )
        serialize(spot)
      end

      delete ":id" do
        authenticate!

        spot = spot = Models::Spot.find_by(id: params[:id]) || raise(ApiError::NotFound)
        spot.destroy
        serialize(spot)
      end
    end
  end
end
