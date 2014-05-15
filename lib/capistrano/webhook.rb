$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))

require 'capistrano/version'
require 'faraday'
require 'json'

module Capistrano
  module Webhook
    def webhooks
      fetch :webhooks, {}
    end

    def do_webhooks_for_event(event)
      return unless webhooks[event]

      puts "Running webhook for event: #{event}"

      webhooks[event].each {|hook| do_webhook hook}
    end

    def do_webhook(hook)
      http_method = hook.shift.to_sym
      if Faraday::Connection::METHODS.include? http_method
        conn = Faraday.new(url: hook.first) do |faraday|
          faraday.response :logger
          faraday.adapter  Faraday.default_adapter
        end

        resp = conn.send http_method, *hook
      else
        puts "Invalid HTTP method <#{http_method}>"
      end
    rescue => e
      puts "Error during webhook: #{e.message}"
    end
  end
end

if defined?(Capistrano::VERSION) && Gem::Version.new(Capistrano::VERSION).release >= Gem::Version.new('3.0.0')
  load File.expand_path('../webhook/v3/tasks.rake', __FILE__)
else
  require 'capistrano/webhook/v2/tasks'
end
