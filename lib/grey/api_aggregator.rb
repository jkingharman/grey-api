# frozen_string_literal: true

require_relative 'spot_api'

module Grey
  class ApiAggregator < Grape::API
    mount Grey::SpotAPI
  end
end
