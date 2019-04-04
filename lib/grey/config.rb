# frozen_string_literal: true

module Grey
  module Config
    extend self

    def logger(log_path: path)
      Logger.new(log_path)
    end
  end
end
