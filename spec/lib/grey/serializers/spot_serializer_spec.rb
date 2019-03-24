# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Grey::SpotSerializer do
  let(:spot_type) do
    Grey::Models::SpotType.new(
      id: 1,
      name: 'Plaza',
      slug: 'plaza',
      spots: []
    )
  end
  let(:spot) do
    Grey::Models::Spot.new(
      id: 1,
      name: 'Canada Water',
      slug: 'canada_water',
      spot_type: spot_type
    )
  end

  describe '#api' do
    it 'serializes the full model' do
      expect(Grey::SpotSerializer.new(:api).serialize(spot)).to eq(
        id: 1, name: 'Canada Water', slug: 'canada_water', created_at: nil,
        spot_type: { name: 'Plaza', slug: 'plaza' }
      )
    end
  end
end
