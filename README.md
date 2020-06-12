# Finances

[![Build Status](https://travis-ci.org/ramonsantos/finances.svg?branch=master)](https://travis-ci.org/ramonsantos/finances)
[![Maintainability](https://api.codeclimate.com/v1/badges/db90ecff0ae3a8718b6d/maintainability)](https://codeclimate.com/github/ramonsantos/finances/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/db90ecff0ae3a8718b6d/test_coverage)](https://codeclimate.com/github/ramonsantos/finances/test_coverage)
![Code Climate technical debt](https://img.shields.io/codeclimate/tech-debt/ramonsantos/finances)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
![ruby](https://img.shields.io/badge/ruby-2.7.1-dc143c)
![rails](https://img.shields.io/badge/rails-6.0.3.1-dc143c)

Web application to manager personal finances.

## Software stack

Finances is a Ruby on Rails application that runs on the following software:

* Linux
* Ruby (MRI) 2.7.1
* Ruby on Rails 6
* NodeJS 12.x
* Yarn 1.x
* Docker
* PostgreSQL 12+

## Getting Started

### Install Ruby

Using [rbenv](https://github.com/rbenv/rbenv)

``` bash
rbenv install 2.7.1
```

### Install PostgreSQL

Using [Docker Compose](https://docs.docker.com/compose/)

``` bash
docker-compose up -d
```

### Install Project Dependencies

#### Ruby dependencies

``` bash
bundle install
```

#### JavaScript dependencies

``` bash
yarn install --check-files
```

### Prepare Database

``` bash
bundle exec rake db:prepare
```

### Run Application

``` bash
foreman start -f Procfile.dev
```

### Run Tests

``` bash
bundle exec rspec
```
