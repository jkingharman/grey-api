# frozen_string_literal: true

module Grey
  class ApiAggregator < Grape::API

  rescue_from ActiveRecord::RecordInvalid do |e|
    env.merge!({ handled_error: { type: "#{e.class.name}", message: "#{e.as_json}"} })

    Rack::Response.new(
      [ {error: e.as_json}.to_json ], 422, { 'Content-type' => 'text/error' }
    )
  end

  rescue_from *Grey::ApiError::ERRORS do |e|
    env.merge!({ handled_error: { type: "#{e.class.name}", message: "#{e.message}" } })

    Rack::Response.new(
      [ {error: e.message}.to_json ], e.status, { 'Content-type' => 'text/error' }
    )
  end

  rescue_from :all do |e|
    error_msg = "Internal server error"
    env.merge!({ handled_error: { type: "RuntimeError", message: error_msg } })

    Rack::Response.new([ {error: error_msg}.to_json ], 500, { 'Content-type' => 'text/error' })
  end

    mount Grey::SpotAPI
    mount Grey::SpotTypeAPI
  end
end
