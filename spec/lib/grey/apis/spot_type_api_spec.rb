# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Grey::SpotTypeAPI do
  #@todo: test failure cases for auth.
  include Rack::Test::Methods

  def serialize(obj)
    serialize_generic(Grey::SpotTypeSerializer, :api, obj)
  end

  let(:app) { Grey::SpotTypeAPI }
  let(:env) { { 'HTTP_AUTHORIZATION' => "Basic " + Base64.encode64("user:secret") } }

  let(:spot_type_one) do
    Grey::Models::SpotType.new(
      id: 1,
      name: 'Plaza',
      slug: 'plaza',
    )
  end

  let(:spot_type_two) do
    Grey::Models::SpotType.new(
      id: 2,
      name: 'Polejam',
      slug: 'polejam',
    )
  end

  before do
    allow(Grey::Models::SpotType).to receive(:find_by).with(id: "1") { spot_type_one }
  end

  describe 'spots' do
    context 'get all' do
      it 'returns all the spots' do
        allow(Grey::Models::SpotType).to receive(:all) { [spot_type_one, spot_type_two] }
        get '/v0/spot_types'
        expect(last_response.status).to eq 200
        expect(response_body).to eq serialize(
          [spot_type_one, spot_type_two]
        )
      end
    end

    context 'get by ID' do
      it 'returns the correct spot' do
         get '/v0/spot_types/1'
         expect(last_response.status).to eq 200
         expect(response_body).to eq serialize(
           spot_type_one
         )
      end
    end

    context 'post with attr' do
      it 'creates a new spot type' do
        spot_type_attr = serialize(spot_type_one)

        allow(Grey::Models::SpotType).to receive(:create!).with(
          name: spot_type_attr['name'], slug: spot_type_attr['slug']
        ) { spot_type_one }

         post '/v0/spot_types/', { spot_type: spot_type_attr }, env
         expect(last_response.status).to eq 201
         expect(response_body).to eq serialize(
           spot_type_one
         )
      end
    end

    context 'put with attr' do
      it 'updates the spot' do
        update_attr = {name: "New name", slug: "new_name"}.stringify_keys!
        allow(spot_type_one).to receive(:update).with(
          name: update_attr['name'], slug: update_attr['slug']
        ) { true }

         put '/v0/spot_types/1', {spot_type: update_attr}, env
         expect(response_body).to eq serialize(
           spot_type_one
         )
      end
    end

    context 'delete by ID' do
      it 'delete the correct spot' do
        allow(spot_type_one).to receive(:delete) { true }

        delete "/v0/spot_types/1", {}, env
        expect(last_response.status).to eq 200
        expect(response_body).to eq({}.to_json)
      end
    end
  end
end
