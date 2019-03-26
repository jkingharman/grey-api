# frozen_string_literal: true

module Grey
  class SpotAPI < Grape::API

    version 'v0', using: :path

    format :json
    default_error_status :json

    helpers do
      def authenticate!; end

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
        spot = Models::Spot.first(id: params[:id])
        serialize(spot)
      end
    end
  end
end
