[![Build Status](https://img.shields.io/travis/JustinAiken/rsprogress_server/master.svg)](https://travis-ci.org/JustinAiken/rsprogress_server)

# RS Progress Dashboard

This is a standard Ruby on Rails app, for tracking Rocksmith progress.   
Currently not hosted anywhere.

![Screenshot](doc/screenshot.png)

## Dependencies

- Standard Ruby Env
- Mysql 5.7+

## Getting started

- `cp .env .env.local` and edit to taste
- Run `rake db:create db:migrate db:seed`
- `rails server`
- Signup as a new user
  - Be sure to set Steam username in Edit Profile!

## Reporting progress

- Use https://github.com/JustinAiken/rsprogress_client after each session

## License

MIT
