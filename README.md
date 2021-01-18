![CI](https://github.com/teogramm/gnomikologikon-fortune-ruby/workflows/CI/badge.svg)
# gnomikologikon-fortune

Gnomiko is the greek word for "quote".

This is an application that downloads quotes from https://gnomikologikon.gr and automatically converts them to files that are ready to use with the fortune command.

## Installation

    $ gem install gnomikologikon-ruby

## Usage

Install and run ``` gnomika ```. The application will ask you about which categories to download. 
Additional options can be viewed with ``` gnomika --help```

If you want the cookies to be available with the fortune command you must copy the generated files to the fortune directory (usually /usr/games/fortune or /usr/fortune).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/teogramm/gnomikologikon-fortune.
