# Pigeon

Pigeon SDK for Ruby

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pigeon-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pigeon-ruby


## Usage

```ruby
Pigeon.deliver('message-identifier', to: 'john@example.com')
```

## Configuration

```ruby
Pigeon.configure do |config|
  config.public_key = ENV['PIGEON_PUBLIC_KEY']
  config.private_key = ENV['PIGEON_PRIVATE_KEY']
end
```

To integrate Pigeon with your Rails application, create a new initializer `config/initializers/pigeon.rb`.

## Examples

### Multiple recipients

```ruby
Pigeon.deliver('message-identifier', {
  to: 'John Doe <john@example.com>',
  cc: ['admin@example.com', 'sales@example.com>']
})
```

### Template variables

Template variables are passed inside `:data`.

```ruby
Pigeon.deliver('message-identifier', {
  to: 'john@example.com',
  data: { name: 'John' }
})
```

### Attachments support

`:file` can be a local file path, remote URL, or a File object.

```ruby
Pigeon.deliver('message-identifier', {
  to: 'jane@example.com',
  attachments: [
    {
      file: '/path/to/handbook.pdf',
      name: 'Handbook'
    }
  ]
})
```

## Development

After checking out the repo, run `bin/setup` to install dependencies and then `overcommit --install` to add hooks. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To ensure consistent code style, this project uses rubocop. You can run `rake rubocop` to see the errors and `rake rubocop:auto_correct` to automatically fix them.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pigeonapp/pigeon-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Releasing

We use the [gem-release](https://github.com/svenfuchs/gem-release) library for versioning, tagging and releasing.

```
gem bump
gem release
gem tag --push
git push origin master
```

Use `gem bump -v [major|minor|patch|pre|release|x.x.x]` for specific version increases.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Pigeon project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/pigeonapp/pigeon-ruby/blob/master/CODE_OF_CONDUCT.md).
