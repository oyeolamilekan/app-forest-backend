# config/initializers/sidekiq.rb
require 'sidekiq'
require 'colorize'

Sidekiq.configure_server do |config|
  config.logger.formatter = proc do |severity, datetime, progname, msg|
    formatted_time = datetime.utc.strftime("%Y-%m-%d %H:%M:%S UTC")
    colored_severity = case severity
                       when "DEBUG"
                         severity.light_blue
                       when "INFO"
                         severity.green
                       when "WARN"
                         severity.yellow
                       when "ERROR"
                         severity.red
                       when "FATAL"
                         severity.red.bold
                       else
                         severity
                       end
    "[#{formatted_time}] #{colored_severity}: #{msg}\n"
  end
end
