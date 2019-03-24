# frozen_string_literal: true

require_relative '../../spec_helper'

describe Grey::V0 do
  include Rack::Test::Methods

  let(:app) { Grey::V0 }

  describe 'spots' do
    it 'gets the latest' do
      get 'v0/spots/latest'
      expect(last_response.status).to eq 200
      expect(last_response.body).to eq({ response: 'wahoo' }.to_json)
    end
  end
end
