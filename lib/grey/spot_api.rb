# frozen_string_literal: true

module Grey
  class SpotAPI < Grape::API
    # Todo implement an error class so serving useful errors is easy.
    # spec the code correctly.
    
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
        spot = Models::Spot.find(params[:id].to_i)
        serialize(spot)
      end
    end
  end
end
