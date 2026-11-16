# frozen_string_literal: true

# Single boot path for every entry point (config.ru, Rakefile, bin/console,
# spec_helper). Callers that need ENV set (tests) must do so before requiring.
require "bundler/setup"
Bundler.require

$LOAD_PATH.unshift(File.expand_path("..", __dir__))
require "grey"

ActiveRecord::Base.establish_connection(Grey::Config.database_url)
