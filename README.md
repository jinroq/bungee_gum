# Bungee Gum

## Description

Bungee Gum collects Ruby building and testing logs. 

This gem gets the latest source code from the [ruby/ruby](https://github.com/ruby/ruby) master branch. Then, build source codes in the same way as ["Building Ruby"](https://docs.ruby-lang.org/en/master/contributing/building_ruby_md.html). And also run tests (i.e. `make test-all`).

Log files are compressed as `.gz` and saved in `logs` directory. `logs` directory will be created in the same directory as the directory where Bungee Gum is executed.

## Installation

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install bungee_gum

Install the gem and add to the application's Gemfile by executing:

    $ bundle add bungee_gum

## Usage

If you installed it yourself:

    $ bgum

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jinroq/bungee_gum. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/jinroq/bungee_gum/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the BungeeGum project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jinroq/bungee_gum/blob/main/CODE_OF_CONDUCT.md).
