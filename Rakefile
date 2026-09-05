# frozen_string_literal: true

require_relative "lib/grey/boot"

namespace :db do
  task :migrate do
    ActiveRecord::MigrationContext.new("db/migrate").migrate(ENV["VERSION"]&.to_i)
  end

  # @todo: fix.
  task :rollback do
    ActiveRecord::MigrationContext.new("db/migrate").rollback(ENV["VERSION"].to_i)
  end
end
