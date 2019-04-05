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
      after { Grey::ApiLogger.log(env, status) }

      get do
        serialize(Models::Spot.all)
      end

      get 'search' do
        spots = Models::Spot.search_by_name(params[:query])
        serialize(spots)
      end

      get 'latest' do
        serialize(Models::Spot.latest)
      end

      get 'random' do
        serialize(Models::Spot.random)
      end

      get ':id' do
        spot = Models::Spot.find_by(id: params[:id]) || raise(ApiError::NotFound)
        serialize(spot)
      end

      post do
        authorize!
        required_params!(:spot)
        spot_type = Models::SpotType.find_by(slug: params[:spot][:spot_type]) || raise(ApiError::NotFound)
        spot = spot_type.spots.create!(
          name: params[:spot][:name], slug: params[:spot][:slug]
        )
        serialize(spot)
      end

      put ':id' do
        authorize!
        required_params!(:spot)
        spot = Models::Spot.find_by(id: params[:id]) || raise(ApiError::NotFound)
        spot.update(
          name: params[:spot][:name], slug: params[:spot][:slug]
        )
        serialize(spot)
      end

      delete ':id' do
        authorize!
        spot = Models::Spot.find_by(id: params[:id]) || raise(ApiError::NotFound)
        spot.destroy
        {}.to_json
      end
    end
  end
end
