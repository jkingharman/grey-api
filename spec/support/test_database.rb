# frozen_string_literal: true

# Pure stdlib so bin/test can load it with plain `ruby` before Bundler.
module TestDatabase
  def self.url
    explicit = ENV['TEST_DATABASE_URL']
    return explicit if explicit && !explicit.empty?

    root = File.expand_path('../..', __dir__)
    suffix = File.basename(root).downcase.gsub(/[^a-z0-9]+/, '_')[0, 50]
    "postgres:///grey_test_#{suffix}"
  end
end
