# Capistrano::Webhook

Simple webhooks for Capistrano deployments.

Supports both Capistrano 2 and 3!

## Installation

Add this line to your application's Gemfile under the 'development' group:

    gem 'capistrano-webhook'

## Usage

In your application's `deploy.rb` file, set a Capistrano variable called `webhooks` to a hash containing a set of callbacks you wish to run during your deployment. The hash keys should be event names (see supported events below) and they should map to arrays representing webhook arguments to send to Faraday. The first item in each webhook should be a valid Farday HTTP method (`:get`, `:post`, etc will map to `Faraday.get`, and `Faraday.post` respectively). All other arguments will be sent in to the Faraday method as arguments with as a splat.

In your `Capfile`:

```
require 'capistrano/webhook'
```

In your `deploy.rb`:

For Cap 2:
```
set :webhooks do
  {
    after_deploy: [
      [:get, "https://ci.example.com", { sha: fetch(:current_revision), app: fetch(:application), env: fetch(:stage) }]
    ]
  }
end
```

Note: if you don't need to run any dynamic methods like `fetch` to determine your webhook, you can specify a plain old Ruby hash instead of a block.


For Cap 3:
```
set :webhooks, {
  after_deploy: [
    [:get, "https://ci.example.com", { sha: fetch(:current_revision), app: fetch(:application), env: fetch(:stage) }]
  ]
}
```

In this example, a `GET` request would be issued to `https://ci.example.com?sha=:current_revision&app=:application&env=:stage`

#### Supported Capistrano Events

```
:before_deploy             # runs before 'deploy'            (Cap 3: 'deploy:started')
:before_deploy_migrations  # runs before 'deploy:migrations' (Cap 3: 'deploy:migrate')
:after_deploy              # runs after  'deploy'            (Cap 3: 'deploy:finished')
:after_deploy_migrations   # runs after  'deploy:migrations' (Cap 3: 'deploy:migrate')
```

#### See also:

For `get`, `head`, and `delete` requests, see: https://github.com/lostisland/faraday/blob/master/lib/faraday/connection.rb#L137

For `post`, `put`, and `patch` requests, see: https://github.com/lostisland/faraday/blob/master/lib/faraday/connection.rb#L174

## TODO

* Deeper Faraday support (POST body, headers, etc)
* ~~Support for Cap 3~~
* Logging enhancements
* Support more (all?) events, maybe custom events

## Contributing

1. Fork it ( http://github.com/<my-github-username>/capistrano-webhook/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
