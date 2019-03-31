# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Grey::SpotAPI do
  #@todo: test failure cases for auth.
  include Rack::Test::Methods

  def serialize(obj)
    serialize_generic(Grey::SpotSerializer, :api, obj)
  end

  let(:app) { Grey::SpotAPI }
  let(:env) { { 'HTTP_AUTHORIZATION' => "Basic " + Base64.encode64("user:secret") } }

  let(:spot_type) do
    Grey::Models::SpotType.new(
      id: 1,
      name: 'Plaza',
      slug: 'plaza',
    )
  end

  let(:spot_one) do
    Grey::Models::Spot.new(
      id: 1,
      name: 'Canada Water',
      slug: 'canada_water',
      spot_type_id: 1
    )
  end

  let(:spot_two) do
    Grey::Models::Spot.new(
      id: 2,
      name: 'Peckham curbs',
      slug: 'peckham_curbs',
      spot_type_id: 1
    )
  end

  before do
    allow(Grey::Models::Spot).to receive(:find_by).with(id: "1") { spot_one }
  end

  describe 'spots' do
    context 'get all' do
      it 'returns all the spots' do
        allow(Grey::Models::Spot).to receive(:all) { [spot_one, spot_two] }
        get '/v0/spots'
        expect(last_response.status).to eq 200
        expect(response_body).to eq serialize(
          [spot_one, spot_two]
        )
      end
    end

    context 'get by ID' do
      it 'returns the correct spot' do
         get '/v0/spots/1'
         expect(last_response.status).to eq 200
         expect(response_body).to eq serialize(
           spot_one
         )
      end
    end

    context 'post with attr' do
      it 'creates a new spot' do
        spot_attr = serialize(spot_one)

        allow(Grey::Models::SpotType).to receive(:find_by).with(
          {slug: "plaza"}
        ) { spot_type }

        allow(spot_type).to receive(:spots) { Grey::Models::Spot }

        allow(Grey::Models::Spot).to receive(:create!).with(
          name: spot_attr['name'], slug: spot_attr['slug']
        ) { spot_one }

         post '/v0/spots/', {spot: spot_attr.merge(spot_type: "plaza")}, env
         expect(last_response.status).to eq 201
         expect(response_body).to eq serialize(
           spot_one
         )
      end
    end

    context 'put with attr' do
      it 'updates the spot' do
        update_attr = {name: "New name", slug: "new_name"}.stringify_keys!
        allow(spot_one).to receive(:update).with(
          name: update_attr['name'], slug: update_attr['slug']
        ) { true }

         put '/v0/spots/1', {spot: update_attr}, env
         expect(response_body).to eq serialize(
           spot_one
         )
      end
    end

    context 'delete by ID' do
      it 'delete the correct spot' do
        allow(spot_one).to receive(:delete) { true }

        delete "/v0/spots/1", {}, env
        expect(last_response.status).to eq 200
        expect(response_body).to eq({}.to_json)
      end
    end
  end
end
