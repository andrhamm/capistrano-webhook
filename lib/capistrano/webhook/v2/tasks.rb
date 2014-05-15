require 'capistrano'

module Capistrano
  module Webhook
    def self.extended(configuration)
      configuration.load do
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

        before 'deploy',            'webhook:before_deploy'
        before 'deploy:migrations', 'webhook:before_deploy_migrations'
        after  'deploy',            'webhook:after_deploy'
        after  'deploy:migrations', 'webhook:after_deploy_migrations'
      end
    end
  end
end

if Capistrano::Configuration.instance
  Capistrano::Configuration.instance.extend(Capistrano::Webhook)
end