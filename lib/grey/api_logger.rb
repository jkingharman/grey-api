# frozen_string_literal: true

module Grey
  class ApiLogger
    BASE_FORMAT = %(%s - %s [%s] "%s %s%s %s %s"\s)
    ERROR_FORMAT = %(%s %s)

    def self.init(path, level: Logger::DEBUG)
      @@logger ||= Logger.new(path)
      @@logger.level = level
    end

    def self.log(env, status, error_opts = {})
      return if Grey::Config.test_env?

      request_msg = format(
        BASE_FORMAT,
        env['HTTP_X_FORWARDED_FOR'] || env['REMOTE_ADDR'] || '-',
        env['REMOTE_USER'] || '-',
        Time.now.strftime('%d/%b/%Y:%H:%M:%S %z'),
        env['REQUEST_METHOD'],
        env['PATH_INFO'],
        env['QUERY_STRING'].empty? ? '' : "?#{env['QUERY_STRING']}",
        env['HTTP_VERSION'],
        status.to_s[0..3]
      )

      msg = if error_opts.keys.all? { |k| %i[type message].include?(k) }
              request_msg + format(
                ERROR_FORMAT,
                error_opts[:type],
                error_opts[:message])
            else
              request_msg
            end

      @@logger << msg + "\n"
    end
  end
end
