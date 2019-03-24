# frozen_string_literal: true

require_relative 'lib/grey'

task :environment do
  if ENV['DATABASE_URL']
    ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
  else
    database = 'lil-grey-development'
    ActiveRecord::Base.establish_connection(database: database, adapter: 'postgresql')
  end
end

namespace :db do
  task migrate: :environment do
    ActiveRecord::MigrationContext.new('db/migrate').migrate(ENV['VERSION'].to_i)
  end

  # TODO: Fix through inspecting: https://github.com/rails/rails/blob/v5.2.0.rc1/activerecord/lib/active_record/migration.rb#L1007

  # task :rollback => :environment do
  #     ActiveRecord::MigrationContext.new("db/migrate").rollback(ENV["STEP"].to_i)
  # end
end
