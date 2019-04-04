# frozen_string_literal: true

require 'bundler/setup'
Bundler.require

require_relative './lib/grey'

require "pry"

Grey::Config.logger
run Grey::ApiAggregator
