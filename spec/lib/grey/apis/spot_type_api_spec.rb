# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Grey::SpotTypeAPI do
  include Rack::Test::Methods

  def serialize(obj)
    serialize_generic(Grey::SpotTypeSerializer, :api, obj)
  end

  let(:app) { Grey::SpotTypeAPI }

  before(:all) do
    @spot_type_one = Grey::Models::SpotType.create(
          id: 1,
          name: 'Plaza',
          slug: 'plaza',
        )

    @spot_type_two = Grey::Models::SpotType.create(
          id: 2,
          name: 'Polejam',
          slug: 'polejam',
        )
  end

  describe 'spot_types' do
    context 'get all' do
      it 'returns all the spot types' do
        get '/v0/spot_types'
        expect(last_response.status).to eq 200
        expect(response_body).to eq serialize(
          [@spot_type_one, @spot_type_two]
        )
      end
    end

    context 'get by ID' do
      it 'returns the correct spot type' do
         get '/v0/spot_types/1'
         expect(last_response.status).to eq 200
         expect(response_body).to eq serialize(
           @spot_type_one
         )
      end
    end
  end
end
