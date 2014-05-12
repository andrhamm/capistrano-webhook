# Capistrano::Webhook

Simple webhooks for Capistrano deployments.

*Currently only supporting Capistrano 2.*

## Installation

Add this line to your application's Gemfile under the 'development' group:

    gem 'capistrano-webhook', require: false

## Usage

In your application's `deploy.rb` file, set a Capistrano variable called `webhooks` to a hash containing a set of callbacks you wish to run during your deployment. The hash keys should be event names (see supported events below) and they should map to arrays representing webhook arguments to send to Faraday. The first item in each webhook should be a valid Farday HTTP method (`:get`, `:post`, etc will map to `Faraday.get`, and `Faraday.post` respectively). All other arguments will be sent in to the Faraday method as arguments with as a splat.

```
require 'capistrano/webhook'
set(:webhooks) do
  {
    after_deploy: [
      [:get, "https://ci.example.com", { sha: fetch(:current_revision), app: fetch(:application), env: fetch(:stage) }]
    ]
  }
end
```

In this example, a `GET` request would be issued to `https://ci.example.com?sha=:current_revision&app=:application&env=:stage`

#### Supported Capistrano Events

```
:before_deploy             # runs before 'deploy'
:before_deploy_migrations  # runs before 'deploy:migrations'
:after_deploy              # runs after  'deploy'
:after_deploy_migrations   # runs after  'deploy:migrations'
```

#### See also:

For `get`, `head`, and `delete` requests, see: https://github.com/lostisland/faraday/blob/master/lib/faraday/connection.rb#L137
For `post`, `put`, and `patch` requests, see: https://github.com/lostisland/faraday/blob/master/lib/faraday/connection.rb#L174

## TODO

* Deeper Faraday support (POST body, headers, etc)
* Support for Cap 3
* Logging enhancements
* Support more events, maybe custom events

## Contributing

1. Fork it ( http://github.com/<my-github-username>/capistrano-webhook/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request