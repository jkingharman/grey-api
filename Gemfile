# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.4.9"

gem "activerecord"
gem "grape"
gem "grape-swagger"
gem "json"
gem "pg"
gem "pg_search"
gem "puma"
gem "rackup"
gem "rake"
gem "rack-cors"

group :development do
  gem "pry"
end

group :development, :test do
  gem "standard"
end

group :test do
  gem "database_cleaner-active_record"
  gem "rack-test"
  gem "rspec"
end
