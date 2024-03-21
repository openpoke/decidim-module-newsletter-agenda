# Decidim::NewsletterAgenda

[![[CI] Lint](https://github.com/openpoke/decidim-module-newsletter_agenda/actions/workflows/lint.yml/badge.svg)](https://github.com/openpoke/decidim-module-newsletter_agenda/actions/workflows/lint.yml)
[![[CI] Test](https://github.com/openpoke/decidim-module-newsletter_agenda/actions/workflows/test.yml/badge.svg)](https://github.com/openpoke/decidim-module-newsletter_agenda/actions/workflows/test.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/7d9a138a045b30851a33/maintainability)](https://codeclimate.com/github/openpoke/decidim-module-newsletter_agenda/maintainability)
[![codecov](https://codecov.io/gh/openpoke/decidim-module-newsletter_agenda/branch/main/graph/badge.svg?token=OZ4AKZGKTC)](https://codecov.io/gh/openpoke/decidim-module-newsletter_agenda)

A template for the Decidim Newsletter focused on an agenda

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'decidim-newsletter_agenda', github: 'openpoke/decidim-module-newsletter_agenda'

```

Run this rake tasks:

```
bundle exec rake decidim_newsletter_agenda:install:migrations
bundle exec rails decidim_newsletter_agenda:webpacker:install
bundle exec rake db:migrate
```

## Usage

This module simply adds a new template for the newsletter, which is focused on events.

### Configuration

This module has been developed to be the main newsletter of the [Canòdrom, Ateneu d'Innovació Digital i Democràtica](https://comunitat.canodrom.barcelona). If you wish to use it, you should configure some defaults for your own organizations.

Create an initializer (for instance `config/initializers/newsletter_agenda.rb`) and configure the following:

loca
```ruby
# config/initializers/newsletter_agenda.rb

Decidim::NewsletterAgenda.configure do |config|
    # The default background color for the newsletter agenda.
    # leave it empty (nil) to use the configured organization's main color.
    # this color can be overriden in the newsletter template builder.
    # hex color code with #, e.g. "#733BCE"
    config.default_background_color = "#733BCE"

    # The default font color over background for the newsletter agenda.
    config.default_font_color_over_bg = "#FFFFFF"

    # The default address text for the newsletter agenda.
    config.default_address_text = <<~ADDRESS
      <b>Canòdrom</b><br>
      <b>Ateneu d'Innovació Digital i Democràtica</b><br>
      C/Concepció Arenal 165 - 09027 Barcelona <a href="https://canodrom.barcelona">canodrom.barcelona</a><br>
      <a href="mailto:hola@canodrom">hola@canodrom.com</a>
    ADDRESS
end
```

## Screenshots

![Newsletter Agenda Template](features/newsletter.png)
![Newsletter Admin](features/admin.png)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/openpoke/decidim-module-newsletter_agenda.

### Developing

To start contributing to this project, first:

- Install the basic dependencies (such as Ruby and PostgreSQL)
- Clone this repository

Decidim's main repository also provides a Docker configuration file if you
prefer to use Docker instead of installing the dependencies locally on your
machine.

You can create the development app by running the following commands after
cloning this project:

```bash
$ bundle
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rake development_app
```

Note that the database user has to have rights to create and drop a database in
order to create the dummy test app database.

Then to test how the module works in Decidim, start the development server:

```bash
$ cd development_app
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rails s
```

In case you are using [rbenv](https://github.com/rbenv/rbenv) and have the
[rbenv-vars](https://github.com/rbenv/rbenv-vars) plugin installed for it, you
can add the environment variables to the root directory of the project in a file
named `.rbenv-vars`. If these are defined for the environment, you can omit
defining these in the commands shown above.

#### Code Styling

Please follow the code styling defined by the different linters that ensure we
are all talking with the same language collaborating on the same project. This
project is set to follow the same rules that Decidim itself follows.

[Rubocop](https://rubocop.readthedocs.io/) linter is used for the Ruby language.

You can run the code styling checks by running the following commands from the
console:

```
$ bundle exec rubocop
```

To ease up following the style guide, you should install the plugin to your
favorite editor, such as:

- Atom - [linter-rubocop](https://atom.io/packages/linter-rubocop)
- Sublime Text - [Sublime RuboCop](https://github.com/pderichs/sublime_rubocop)
- Visual Studio Code - [Rubocop for Visual Studio Code](https://github.com/misogi/vscode-ruby-rubocop)

### Testing

To run the tests run the following in the gem development path:

```bash
$ bundle
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rake test_app
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rspec
```

Note that the database user has to have rights to create and drop a database in
order to create the dummy test app database.

In case you are using [rbenv](https://github.com/rbenv/rbenv) and have the
[rbenv-vars](https://github.com/rbenv/rbenv-vars) plugin installed for it, you
can add these environment variables to the root directory of the project in a
file named `.rbenv-vars`. In this case, you can omit defining these in the
commands shown above.

### Test code coverage

If you want to generate the code coverage report for the tests, you can use
the `SIMPLECOV=1` environment variable in the rspec command as follows:

```bash
$ SIMPLECOV=1 bundle exec rspec
```

This will generate a folder named `coverage` in the project root which contains
the code coverage report.

### Localization

If you would like to see this module in your own language, you can help with its
translation at Crowdin:

https://crowdin.com/project/decidim-newsletter-agenda

## License

See [LICENSE-AGPLv3.txt](LICENSE-AGPLv3.txt).
