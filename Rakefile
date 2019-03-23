require_relative "lib/grey"

task :environment do
  if ENV["DATABASE_URL"]
    ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"])
  else
    database = "grey-#{ENV["ENV"] || "development"}"
    ActiveRecord::Base.establish_connection(database: database, adapter: "postgresql")
  end
end
