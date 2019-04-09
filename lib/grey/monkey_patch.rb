# frozen_string_literal: true

module Rack
  class CommonLogger
    def log(env, status, header, began_at)
    # @todo: explain why I've monkey patched here.
    end
  end
end
