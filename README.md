# Migraine Ruby Gem

## Introduction

Migraine is a simple gem to assist in writing data migration
scripts in Ruby. It supports various database adapters (e.g.
MySQL, SQLite3, PostgreSQL) through its only dependency; the
Sequel Ruby gem.

## Requirements

* Ruby 1.9
* [Sequel](https://github.com/jeremyevans/sequel)

## Installation

    myproject.com
     > gem install migraine

## Usage

### Create migration file

    myproject.com
     > vim migrate.rb

### Tell Migraine what and where to migrate

    require "migraine"
    
    migration = Migraine::Migration.new(
      from: "mysql://root:root@localhost/myproj_old",
      to:   "mysql://root:root@localhost/myproj"
    )
    
    migration.map "products" => "spree_products"
    migration.map "users" => "spree_users" do
      map "crypted_password" => "encrypted_password"
      map "salt" => "password_salt"
    
      map "remember_token"
      map "persistance_token"
      map "perishable_token"
    end

    migration.run

### Run migration file

    myproject.com
     > ruby migrate.rb
