# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Grey::SpotAPI do
  include Rack::Test::Methods

  def serialize(obj)
    serialize_generic(Grey::SpotSerializer, :api, obj)
  end

  let(:app) { Grey::SpotAPI }

  let(:spot_one) do
    Grey::Models::Spot.new(
      id: 1,
      name: 'Canada Water',
      slug: 'canada_water',
      spot_type: nil
    )
  end

  let(:spot_two) do
    Grey::Models::Spot.new(
      id: 2,
      name: 'Peckham curbs',
      slug: 'peckham_curbs',
      spot_type: nil
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
        expect(JSON.parse(last_response.body)).to eq serialize(
          [spot_one, spot_two]
        )
      end
    end

    context 'get by ID' do
      it 'returns the correct spot' do
         get '/v0/spots/1'
         expect(last_response.status).to eq 200
         expect(JSON.parse(last_response.body)).to eq serialize(
           spot_one
         )
      end
    end

    context 'post with attr' do
      it 'creates a new spot' do
        spot_attr = serialize(spot_one)

        allow(Grey::Models::Spot).to receive(:create!).with(
          name: spot_attr['name'], slug: spot_attr['slug']
        ) { spot_one }

         post '/v0/spots/', spot: spot_attr
         expect(last_response.status).to eq 201
         expect(JSON.parse(last_response.body)).to eq serialize(
           spot_one
         )
      end
    end

    context 'put with attr' do
      it 'updates the spot' do
        update_attr = {"name" => "New name", "slug" => "new_name"}
        allow(spot_one).to receive(:update).with(
          name: update_attr['name'], slug: update_attr['slug']
        ) { true }

         put '/v0/spots/1', spot: update_attr
         expect(JSON.parse(last_response.body)).to eq serialize(
           spot_one
         )
      end
    end

    context 'delete by ID' do
      it 'delete the correct spot' do
        allow(spot_one).to receive(:delete) { true }

        delete "/v0/spots/1"
        expect(last_response.status).to eq 200
        expect(JSON.parse(last_response.body)).to eq serialize(spot_one)
      end
    end
  end
end
