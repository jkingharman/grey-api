# frozen_string_literal: true

require_relative '../../../spec_helper'

describe Grey::Models::Spot do

  it "validates slug format" do
    expect(Grey::Models::SpotType.new(name: "Handrail", slug: "handrail").valid?).to be true
    expect(Grey::Models::SpotType.new(name: "Jumpramp", slug: "jumpramp22").valid?).to be true
    expect(Grey::Models::SpotType.new(name: "Manny Pad", slug: "manny-pad").valid?).to be true

    expect(Grey::Models::SpotType.new(name: "Kicker", slug: "-kicker").valid?).to be false
    expect(Grey::Models::SpotType.new(name: "Hill bomb", slug: "hillbomb!").valid?).to be false
    expect(Grey::Models::SpotType.new(name: "Flat bar", slug: "!flatbar").valid?).to be false
  end
end
