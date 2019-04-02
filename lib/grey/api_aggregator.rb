# frozen_string_literal: true

module Grey
  class ApiAggregator < Grape::API

  rescue_from ActiveRecord::RecordInvalid do |e|
    #@todo: log the error and backtrace.

    Rack::Response.new(
      [ {error: e.as_json}.to_json ], 422, { 'Content-type' => 'text/error' }
    )
  end

  rescue_from *Grey::ApiError::ERRORS do |e|
    #@todo: log the error and backtrace.

    Rack::Response.new(
      [ {error: e.message}.to_json ], e.status, { 'Content-type' => 'text/error' }
    )
  end

  rescue_from :all do |e|
    #@todo: log the error and backtrace.
    Rack::Response.new([ {error: "Internal server error"}.to_json ], 500, { 'Content-type' => 'text/error' })
  end

    mount Grey::SpotAPI
    mount Grey::SpotTypeAPI
  end
end
