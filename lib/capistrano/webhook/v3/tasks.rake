namespace :webhook do
  task :before_deploy do
    on roles(:db) do
      Capistrano::Webhook.new.do_webhooks_for_event :before_deploy
    end
  end
  task :before_deploy_migrations do
    on roles(:db) do
      Capistrano::Webhook.new.do_webhooks_for_event :before_deploy_migrations
    end
  end
  task :after_deploy do
    on roles(:db) do
      Capistrano::Webhook.new.do_webhooks_for_event :after_deploy
    end
  end
  task :after_deploy_migrations do
    on roles(:db) do
      Capistrano::Webhook.new.do_webhooks_for_event :after_deploy_migrations
    end
  end

  before 'deploy:started',  'webhook:before_deploy'
  before 'deploy:migrate',  'webhook:before_deploy_migrations'
  after  'deploy:finished', 'webhook:after_deploy'
  after  'deploy:migrate',  'webhook:after_deploy_migrations'
end