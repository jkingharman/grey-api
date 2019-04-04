# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Grey::SpotTypeAPI do
  #@todo: remove mocking
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

  describe 'spot_types' do
    context 'get all' do
      it 'returns all the spot types' do
        allow(Grey::Models::SpotType).to receive(:all) { [spot_type_one, spot_type_two] }
        get '/v0/spot_types'
        expect(last_response.status).to eq 200
        expect(response_body).to eq serialize(
          [spot_type_one, spot_type_two]
        )
      end
    end

    context 'get by ID' do
      it 'returns the correct spot type' do
         get '/v0/spot_types/1'
         expect(last_response.status).to eq 200
         expect(response_body).to eq serialize(
           spot_type_one
         )
      end
    end
  end
end
