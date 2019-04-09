# frozen_string_literal: true

module Grey
  module Api
    class SpotAPI < Grape::API
      version 'v0', using: :path

      format :json
      default_error_status :json

      helpers do
        include Api::Helpers

        def serializer
          @serializer ||= Grey::Serializers::SpotSerializer.new(:api)
        end

        def serialize(obj)
          serializer.serialize(obj)
        end
      end

      resource :spots do
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
          spot = Models::Spot.find_by(id: params[:id]) || raise(Error::NotFound)
          serialize(spot)
        end

        post do
          authorize!
          required_params!(:spot)
          spot_type = Models::SpotType.find_by(slug: params[:spot][:spot_type]) || raise(Error::NotFound)
          spot = spot_type.spots.create!(
            name: params[:spot][:name], slug: params[:spot][:slug]
          )
          serialize(spot)
        end

        put ':id' do
          authorize!
          required_params!(:spot)
          spot = Models::Spot.find_by(id: params[:id]) || raise(Error::NotFound)
          spot.update(
            name: params[:spot][:name], slug: params[:spot][:slug]
          )
          serialize(spot)
        end

        delete ':id' do
          authorize!
          spot = Models::Spot.find_by(id: params[:id]) || raise(Error::NotFound)
          spot.destroy
          {}.to_json
        end
      end
    end
  end
end
