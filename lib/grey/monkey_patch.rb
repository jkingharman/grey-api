#@todo: write a comment to explain why I've monkey patched CommonLogger
module Rack
  class CommonLogger
    BASE_FORMAT = %{%s - %s [%s] "%s %s%s %s" %d %s %0.4f\s}
    ERROR_FORMAT = %{%s %s\n}

    private

    def log(env, status, header, began_at)
      length = extract_content_length(header)

      base_msg = BASE_FORMAT % [
        env['HTTP_X_FORWARDED_FOR'] || env["REMOTE_ADDR"] || "-",
        env["REMOTE_USER"] || "-",
        Time.now.strftime("%d/%b/%Y:%H:%M:%S %z"),
        env[REQUEST_METHOD],
        env[PATH_INFO],
        env[QUERY_STRING].empty? ? "" : "?#{env[QUERY_STRING]}",
        env[HTTP_VERSION],
        status.to_s[0..3],
        length,
        Utils.clock_time.to_f - began_at.to_f ]

      msg = unless env[:handled_error]
              base_msg
            else
              base_msg + ERROR_FORMAT % [
                env[:handled_error][:type],
                env[:handled_error][:message],
              ]
            end

      logger = @logger || env[RACK_ERRORS]
      # Standard library logger doesn't support write but it supports << which actually
      # calls to write on the log device without formatting
      if logger.respond_to?(:write)
        logger.write(msg)
      else
        logger << msg
      end
    end
  end
end
