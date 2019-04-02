require_relative '../../spec_helper'

describe Grey::ApiAggregator do
  include Rack::Test::Methods

  let(:app) { Grey::ApiAggregator }

  it 'catch all rescues from errors' do
    allow(Grey::Models::Spot).to receive(:find_by) { raise "error" }
    
    get 'v0/spots/1000'
    expect(last_response.status).to eq 500
    expect(response_body).to eq(
      stringify_keys({ error: 'Internal server error' })
      )
  end
end
