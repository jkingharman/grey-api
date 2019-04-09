# frozen_string_literal: true

require 'grape'
require 'pg_search'
require 'active_record'
require 'grape-swagger'
require 'rack/cors'

require_relative './grey/config'
require_relative './grey/monkey_patch'

require_relative './grey/api_log_line_emitter'
require_relative './grey/middleware/api_log_line'
require_relative './grey/middleware/instrumentation'

require_relative './grey/api/errors.rb'
require_relative './grey/api/helpers.rb'
require_relative './grey/api/spot_api.rb'
require_relative './grey/api/spot_type_api.rb'
require_relative './grey/api_aggregator.rb'

require_relative './grey/models/spot'
require_relative './grey/models/spot_type'

require_relative './grey/serializers/base_serializer'
require_relative './grey/serializers/spot_serializer'
require_relative './grey/serializers/spot_type_serializer'
