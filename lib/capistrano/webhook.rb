require "capistrano/webhook/version"
require 'capistrano'
require 'json'
require 'faraday'

module Capistrano
  module Webhook
    def self.extended(configuration)
      configuration.load do

        before 'deploy',            'webhook:before_deploy'
        before 'deploy:migrations', 'webhook:before_deploy_migrations'
        after  'deploy',            'webhook:after_deploy'
        after  'deploy:migrations', 'webhook:after_deploy_migrations'

        namespace :webhook do
          task :before_deploy do
            do_webhooks_for_event :before_deploy
          end
          task :before_deploy_migrations do
            do_webhooks_for_event :before_deploy_migrations
          end
          task :after_deploy do
            do_webhooks_for_event :after_deploy
          end
          task :after_deploy_migrations do
            do_webhooks_for_event :after_deploy_migrations
          end
        end

      end
    end

    def webhooks
      @webhooks ||= fetch(:webhooks, {})
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

if Capistrano::Configuration.instance
  Capistrano::Configuration.instance.extend(Capistrano::Webhook)
end