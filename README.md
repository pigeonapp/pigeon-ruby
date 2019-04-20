# Pigeon

Pigeon SDK for Ruby

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pigeon'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pigeon

## Usage

```ruby
parcel = { to: 'john@example.com' }

Pigeon.deliver('message-identifier', parcel)
```

- Message identifier is used to identify the message. Grab this from your [Pigeon](https://pigeonapp.io) dashboard.
- Parcel accepts `to`, `cc`, `bcc`, `data` and `attachments`.


### Parcel sample (Single recipient)

```ruby
parcel = {
  to: 'John Doe <john@example.com>',
  cc: [
    'admin@example.com',
    'Sales Team <sales@example.com>'
  ],
  data: {
    # template variables are added here
    name: 'John'
  }
  attachments: [
    # :file can be a remote URL, local file path, or a File object
    {
      file: 'https://example.com/guide.pdf',
      name: 'Guide'
    },
    {
      file: '/path/to/logo.png',
      name: 'Logo'
    }
  ]
}
```

### Parcel sample (Multiple recipients)

```ruby
parcels = [
  {
    to: 'John Doe <john@example.com>',
    data: {
      # template variables are added here
      name: 'John'
    }
  },
  {
    to: 'Jane Doe <jane@example.com>',
    data: {
      # template variables are added here
      name: 'Jane'
    }
  }
]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

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
