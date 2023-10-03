# MeritCourse

A Learning Management System / Content Management System built as a one time licensing deal with TimothySmithNetwork.org.

## Features

Ruby 3.0.0
Rails 7.0.4.1
MySQL 8.0

## Installation Instructions

Install rvm and Ruby 3.0.0

```
brew install rvm
rvm install 3.0.0
```

Install bundler

```
gem install bundler
```

Install and start mysql

```
brew tap
brew install mysql
mysql.server start
```

Install mysql2 gem using the appropriate system configuration flags.

`gem install mysql2 -- --with-mysql-config=/usr/local/bin/mysql_config --with-ldflags=-L/usr/local/Cellar/openssl/1.0.2t/lib --with-cppflags=-I/usr/local/Cellar/openssl/1.0.2t/include`


Install the rest of the gems.

`bundle`

Install redis

`brew install redis-server`

Start the redis server
`redis-server`

In a new tab create the database and run migrations

`rails db:create`
`rails db:migrate`

Seed the database

`rails db:seed`

## Site Instructions

Visit http://localhost:3000

## Login Instructions (Admin)

Visit http://localhost:3000/dashboard

Sign up a new user

Use the sign up key `helloworld`.

Have fun.
