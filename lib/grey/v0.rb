module Grey
  class V0 < Grape::API
    version 'v0', using: :path

    format :json
    default_error_status :json

    resource :spots do
      get :latest do
        { response: "wahoo" }
      end
    end
  end
end
