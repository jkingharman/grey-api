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

  describe 'spots' do
    context 'get all' do
      it 'returns all the spots' do
        allow(Grey::Models::Spot).to receive(:all).and_return(
          [spot_one, spot_two]
        )

        get '/v0/spots'
        expect(last_response.status).to eq 200
        expect(JSON.parse(last_response.body)).to eq serialize(
          [spot_one, spot_two]
        )
      end
    end
  end
end
