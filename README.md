[![Build Status](https://travis-ci.org/kkirsche/rubygems_api.svg?branch=master)](https://travis-ci.org/kkirsche/rubygems_api) [![Code Climate](https://codeclimate.com/github/kkirsche/rubygems_api/badges/gpa.svg)](https://codeclimate.com/github/kkirsche/rubygems_api) [![Test Coverage](https://codeclimate.com/github/kkirsche/rubygems_api/badges/coverage.svg)](https://codeclimate.com/github/kkirsche/rubygems_api)

# RubyGems API Client

Welcome to the RubyGems API gem! In this repository, you'll find the files you need to be able to interact with the RubyGems API quickly and easily.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rubygems_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rubygems_api

## Usage

Add this line to your application's Gemfile:

```ruby
gem 'rubygems_api'
```

Require the gem:

```ruby
require 'rubygems_api'
```

And then begin working:

```ruby
rubygems = Rubygems::API::Client.new 'myAPIKey'
# If you don't want to include the API key when creating the client, you can retrieve it with HTTP basic auth.
rubygems.set_api_key('username', 'password')

# Begin working with the api
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/kkirsche/rubygems_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
