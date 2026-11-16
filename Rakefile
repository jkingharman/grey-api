# frozen_string_literal: true

require_relative "lib/grey/boot"

namespace :db do
  # Idempotent: connects to the maintenance DB, creates the target if absent,
  # then restores the app connection. Reachability problems surface here.
  task :create do
    url = Grey::Config.database_url
    name = url.split("/").last
    maintenance_url = url.sub(/[^\/]+\z/, "postgres")
    begin
      ActiveRecord::Base.establish_connection(maintenance_url)
      ActiveRecord::Base.connection.create_database(name)
      puts "Created database #{name}"
    rescue ActiveRecord::DatabaseAlreadyExists
      puts "Database #{name} already exists"
    rescue ActiveRecord::ConnectionNotEstablished, PG::ConnectionBad => e
      abort "Cannot reach Postgres via #{maintenance_url}. Is it running?\n#{e.message}"
    ensure
      ActiveRecord::Base.establish_connection(url)
    end
  end

  task :migrate do
    ActiveRecord::MigrationContext.new("db/migrate").migrate(ENV["VERSION"]&.to_i)
  end

  # @todo: fix.
  task :rollback do
    ActiveRecord::MigrationContext.new("db/migrate").rollback(ENV["VERSION"].to_i)
  end
end
