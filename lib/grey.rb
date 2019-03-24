# frozen_string_literal: true

require 'pry'
require 'grape'
require 'active_record'

# For testing only!
ActiveRecord::Base.establish_connection database: 'lil-grey-development', adapter: 'postgresql'

require_relative './grey/api_aggregator'

require_relative './grey/models/spot'
require_relative './grey/models/spot_type'

require_relative './grey/serializers/base_serializer'
require_relative './grey/serializers/spot_serializer'
require_relative './grey/serializers/spot_type_serializer'
