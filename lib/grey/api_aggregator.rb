# frozen_string_literal: true

module Grey
  class ApiAggregator < Grape::API
    rescue_from ActiveRecord::RecordInvalid do |e|
      env['grey.error'] = e

      Rack::Response.new(
        [{ error: e.as_json }.to_json], 422, 'Content-type' => 'text/error'
      )
    end

    rescue_from(*Grey::Api::Error::ERRORS) do |e|
      env['grey.error'] = e

      Rack::Response.new(
        [{ error: e.message }.to_json], e.status, 'Content-type' => 'text/error'
      )
    end

    rescue_from :all do |e|
      env['grey.error'] = e
      error_msg = 'Internal server error'

      Rack::Response.new([{ error: error_msg }.to_json], 500, 'Content-type' => 'text/error')
    end

    mount Grey::Api::SpotAPI
    mount Grey::Api::SpotTypeAPI

    add_swagger_documentation \
      hide_documentation_path: true,
      mount_path: '/swagger_doc',
      markdown: false,
      api_version: 'v0'
  end
end
