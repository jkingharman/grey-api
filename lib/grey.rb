# frozen_string_literal: true

require 'grape'
require 'pg_search'
require 'active_record'

# For testing only!
ActiveRecord::Base.establish_connection database: 'lil-grey-development', adapter: 'postgresql'

require_relative './grey/config'
require_relative './grey/api_logger'
require_relative './grey/monkey_patch'

require_relative './grey/apis/errors.rb'
require_relative './grey/apis/helpers.rb'
require_relative './grey/apis/spot_api.rb'
require_relative './grey/apis/spot_type_api.rb'
require_relative './grey/api_aggregator.rb'

require_relative './grey/models/spot'
require_relative './grey/models/spot_type'

require_relative './grey/serializers/base_serializer'
require_relative './grey/serializers/spot_serializer'
require_relative './grey/serializers/spot_type_serializer'
