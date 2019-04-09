# frozen_string_literal: true

module Grey
  # https://blog.codeship.com/logfmt-a-log-format-thats-easy-to-read-and-write/
  # My log lines conform to the format of log messages produced by Heroku's router: "logfmt".
  class LogLineFmtr
    def initialize(datetime_format = nil)
      @datetime_format = datetime_format || '%Y-%m-%d %H:%M:%S %z'
    end

    def call(severity, datetime, progname, msg)
      if msg.is_a? Hash
        msg_str = logfmtify_hash(msg)
        %(level=#{severity} datetime="#{datetime.strftime(@datetime_format)}" progname=#{progname} #{msg_str}\n)
      end
    end

    private

    def logfmtify_hash(msg)
      msg.collect do |key, value|
        value = add_quotes(escape_newlines(value))
        %(#{key}=#{value})
      end.join(' ')
    end

    def add_quotes(msg)
      if needs_quotes(msg)
        %("#{msg}")
      else
        msg.to_s
      end
    end

    def needs_quotes(msg)
      if /[^a-zA-Z0-9\-\.]/.match?(msg.to_s)
        true
      else
        false
      end
    end

    def escape_newlines(msg)
      msg.to_s.gsub(/\n/, '\\n')
    end
  end

  class ApiLogLineEmitter
    def initialize(logger:)
      @logger = logger
      @logger.formatter = Grey::LogLineFmtr.new
    end

    def call(log_line)
      @logger.info(log_line)
    end
  end
end
