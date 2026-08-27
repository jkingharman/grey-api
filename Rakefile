# frozen_string_literal: true

require 'bundler/setup'
Bundler.require

$LOAD_PATH << './lib'
require_relative 'lib/grey'

task :environment do
  ActiveRecord::Base.establish_connection(Grey::Config.database_url)
end

namespace :db do
  task migrate: :environment do
    ActiveRecord::MigrationContext.new('db/migrate').migrate(ENV['VERSION']&.to_i)
  end

  # @todo: fix.
  task rollback: :environment do
    ActiveRecord::MigrationContext.new('db/migrate').rollback(ENV['VERSION'].to_i)
  end
end
