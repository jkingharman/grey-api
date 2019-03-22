require_relative "v0"

module Grey
  class ApiAggregator < Grape::API
    mount Grey::V0
  end
end
