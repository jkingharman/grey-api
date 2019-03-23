require "pry"
require "grape"
require "active_record"

# For testing only!
ActiveRecord::Base.establish_connection database: "lil-grey-development", adapter: "postgresql"

require_relative "./grey/api_aggregator"

require_relative "./grey/models/spots"
require_relative "./grey/models/spot_types"

binding.pry
