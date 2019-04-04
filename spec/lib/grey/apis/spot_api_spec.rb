# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Grey::SpotAPI do
  include Rack::Test::Methods

  def serialize(obj)
    serialize_generic(Grey::SpotSerializer, :api, obj)
  end

  let(:app) { Grey::SpotAPI }
  let(:env) { { 'HTTP_AUTHORIZATION' => "Basic " + Base64.encode64("user:secret") } }

  before(:all) do
    @spot_type = Grey::Models::SpotType.create(
          id: 1,
          name: 'Plaza',
          slug: 'plaza',
        )

    @spot_one = Grey::Models::Spot.create(
          name: 'Canada Water',
          slug: 'canada_water',
          spot_type: @spot_type
        )

    @spot_two = Grey::Models::Spot.create(
          name: 'Peckham curbs',
          slug: 'peckham_curbs',
          spot_type: @spot_type
        )
  end


  describe 'spots' do
    context 'get all' do
      it 'returns all the spots' do
        get '/v0/spots'
        expect(last_response.status).to eq 200
        expect(response_body).to eq serialize(
          [@spot_one, @spot_two]
        )
      end
    end

    context 'get by ID' do
      it 'returns the correct spot' do
         get '/v0/spots/1'
         expect(last_response.status).to eq 200
         expect(response_body).to eq serialize(
           @spot_one
         )
      end
    end

    context 'post with attr' do
      it 'fails without auth' do
        spot_attr = serialize(@spot_one)

        expect{post '/v0/spots/', {spot: spot_attr} }.to raise_error(
          Grey::ApiError::Unauthorized
        )
      end

      it 'creates a new spot' do
        new_spot_attr = serialize(
          Grey::Models::Spot.new(
            name: 'SB',
            slug: 'sb',
            spot_type: @spot_type
          )
        )
         new_spot_attr["spot_type"] = "plaza"

         post '/v0/spots/', {spot: new_spot_attr }, env
         expect(last_response.status).to eq 201
         expect(response_body).to eq(
           stringify_keys({
             id: response_body["id"],
             name: "SB",
             slug: "sb",
             spot_type: response_body["spot_type"]
             }
          )
        )
      end
    end

    context 'put with attr' do
      it 'fails without auth' do
        update_attr = stringify_keys({name: "New name", slug: "new_name"})
        expect{put '/v0/spots/1', spot: update_attr }.to raise_error(
          Grey::ApiError::Unauthorized
        )
      end

      it 'updates the spot' do
        update_attr = stringify_keys({name: "New name", slug: "new_name"})

         put '/v0/spots/1', {spot: update_attr}, env
         expect(response_body).to eq(
           stringify_keys({
             id: response_body["id"],
             name: "New name",
             slug: "new_name",
             spot_type: response_body["spot_type"]
             })
         )
      end
    end

    context 'delete by ID' do
      it 'fails without auth' do
        expect{delete '/v0/spots/1', {} }.to raise_error(
          Grey::ApiError::Unauthorized
        )
      end

      it 'delete the correct spot' do
        delete "/v0/spots/1", {}, env
        expect(last_response.status).to eq 200
        expect(response_body).to eq({}.to_json)
      end
    end
  end
end
