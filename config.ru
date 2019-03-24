# frozen_string_literal: true

require 'bundler/setup'
Bundler.require

require_relative './lib/grey'

run Grey::ApiAggregator
