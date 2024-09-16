# MessageMe

> [!NOTE]
> This is an example project to demonstrate my coding skills. It is not actively maintained.

## Local Development Setup

### Requirements

* Ruby 3+ (see .ruby-version file)
* PostgreSQL 16+

### App setup

After installing Ruby and PostgreSQL, follow these steps:

1. Run `bundle install` to install all necessary Gems
2. Run `bin/setup` to prepare the database
3. Run `rake fake_data:users` if you want to create some sample users (optional)
4. Execute `bin/dev` to run the app locally

## App Features

This is a 1-to-1 chat application that uses ActionCable features:

* Users can search for and chat with other users
* Users can send messages to other users
* Users receive browser notifications when they receive a message

## Testing

Test the application with RSpec by running the command `bundle exec rspec`.
