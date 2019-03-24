# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Grey::SpotTypeSerializer do
  let(:spot) do
    Grey::Models::Spot.new(
      id: 1,
      name: 'Canada Water',
      slug: 'canada_water',
      spot_type: nil
    )
  end

  let(:spot_type) do
    Grey::Models::SpotType.new(
      id: 1,
      name: 'Plaza',
      slug: 'plaza',
      spots: [spot]
    )
  end

  describe '#api' do
    it 'serializes the full model' do
      expect(Grey::SpotTypeSerializer.new(:api).serialize(spot_type)).to eq(
        id: 1, name: 'Plaza', slug: 'plaza', created_at: nil,
        spots: [{ name: 'Canada Water', slug: 'canada_water' }]
      )
    end
  end
end
