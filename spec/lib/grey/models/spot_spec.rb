# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Grey::Models::Spot do

  let(:spot_type) do
    Grey::Models::SpotType.new(
      id: 3,
      name: 'Ledge',
      slug: 'ledge',
      spots: []
    )
  end

  it "validates slug format" do
    expect(Grey::Models::Spot.new(name: "Southbank", slug: "southbank", spot_type: spot_type).valid?).to be true
    expect(Grey::Models::Spot.new(name: "Viccy Benches", slug: "0viccybenches", spot_type: spot_type).valid?).to be true
    expect(Grey::Models::Spot.new(name: "CW", slug: "canada-water", spot_type: spot_type).valid?).to be true

    expect(Grey::Models::Spot.new(name: "Blobland", slug: "-blobland", spot_type: spot_type).valid?).to be false
    expect(Grey::Models::Spot.new(name: "Saint Pauls", slug: "saintpauls!", spot_type: spot_type).valid?).to be false
    expect(Grey::Models::Spot.new(name: "New spot", slug: "!newspot", spot_type: spot_type).valid?).to be false
  end
end
