# Migraine Ruby Gem

## Introduction

Have you ever felt enthusiastic about migrating data from one
database to another? Me neither. Migraine is a simple gem to
assist in writing data migration scripts in Ruby. It supports
various database adapters (e.g. MySQL, SQLite3, PostgreSQL)
through its only dependency, the
[Sequel](https://github.com/jeremyevans/sequel) Ruby gem.

## Requirements

* Ruby 1.9
* [Sequel](https://github.com/jeremyevans/sequel)

## Installation

    myproject.com
     > gem install migraine

## TODO

1. `Migraine::Map#map` (or separate method) should be able to deal
   with column type differences between source and destination. The
   method should accept a block argument that takes source record
   as input, and relies on developer to manipulate that data and
   return valid destination data.

        migration.map 'table' do
          map 'column' => 'new_column' do |source|
            destination = "A new string from #{source}"
            destination.upcase

            destination
          end
        end

## Using Migraine

### Create migration file

    myproject.com
     > vim migrate.rb

### The migration file

You must now tell Migraine what data you want to migrate, and
where. But first require the Migraine gem.

    require 'migraine'

Create a migration, specifying source and destination databases.
For information about how to write the connection URI's, see the
documentation of [Sequel](https://github.com/jeremyevans/sequel).
It's very simple, I promise.

    migration = Migraine::Migration.new(
      from: "mysql://root:root@localhost/myproj_old",
      to:   "mysql://root:root@localhost/myproj"
    )

Map source tables to destination tables. If the columns are
unchanged in the destination table, you do not need to provide
any block with instructions. Simply map source table to
destination table.
    
    migration.map "products" => "spree_products"

If source and destination tables have the same name in both
databases, you can make it even shorter.

    migration.map "products"

On the other hand, if the column names have changed at the
destination, you can provide instructions on how to map them.

    migration.map "users" => "spree_users" do
      map "crypted_password" => "encrypted_password"
      map "salt" => "password_salt"
    
      map "remember_token"
      map "persistance_token"
      map "perishable_token"
    end

**TODO:** In the future, Migraine will provide methods for dealing
with differences in column types. You should then be able to tell
Migraine how you want it to convert data from a source record to
a destination record. This will probably be done by passing a
block that takes source data as input, and relies on you to
manipulate it and return the destination data.

When you have provided the mappings, tell Migraine that you want
to run the migration.

    migration.run

### Run migration file

    myproject.com
     > ruby migrate.rb

## Generating migrations

Migraine can even generate migration files for you. This is
useful for databases with many tables, where you don't want to
type them all out manually.

### Adapter support

At the moment, Migraine can only generate migrations
for MySQL databases. This is because to analyze the differences
between source and destination, we need to generate database
schemas as Hashes. Right now there is only a method for MySQL.

Please feel free to add methods for other adapters as well. You
can do this by forking Migraine and
`lib/migraine/schema_generator.rb` and add a new method. The file
is commented with further instructions.

### Create generation file

You will need to create a file with generation instructions, just
like you create a file for migrations.

    myproject.com
     > vim generate.rb

### The generation file

All you need to do in your new Ruby file is to create a
`Migraine::Migration` with a source and destination, and tell
Migraine to generate a migration file for it.

    migration = Migraine::Migration.new(
      from: "mysql://root:root@localhost/myproj_old",
      to:   "mysql://root:root@localhost/myproj"
    )

    migration.generate 'migrate.rb'

When you run this file using `ruby generate.rb` or similar, it
will create a migrate.rb file containing table and column
mappings.

Migraine will try to determine the mappings by analyzing the
differences between source and destination. When it can't, it
will simply leave the destinations empty for you to fill in.

### Table prefixes

If the destination database has many of the same tables as
source, but with an added prefix (e.g. source table 'users'
should be mapped to destination table 'spree_users'), you can use
the prefix method to tell Migraine about it and, and it will
consider that when looking for destination tables.

Add the following before your call to `Migration#generate`.

    migration.prefix 'spree_'

### Example

Following is a generation file and part of its resulting
migration file (abbreviated since Spree has many tables.)

#### generate.rb

    require 'migraine'

    migration = Migraine::Migration.new(
      from: 'mysql://root:root@localhost/migraine_from',
      to: 'mysql://root:root@localhost/migraine_to'
    )

    migration.prefix 'spree_'
    migration.generate 'generated.rb'

#### ruby generate.rb

#### generated.rb

    require 'migraine'

    migration = Migraine::Migration.new(
      from: 'mysql://root:root@localhost/migraine_from',
      to: 'mysql://root:root@localhost/migraine_to'
    )

    migration.map 'addresses' => 'spree_addresses'
      map 'id'
      map 'firstname'
      map 'lastname'
      map 'address1'
      map 'address2'
      map 'city'
      map 'state_id'
      map 'zipcode'
      map 'country_id'
      map 'phone'
      map 'created_at'
      map 'updated_at'
      map 'state_name'
      map 'alternative_phone'
    end

    migration.map 'adjustments' => 'spree_adjustments'
      map 'id'
      map 'order_id' => ''
      map 'type' => ''
      map 'amount'
      map 'description' => ''
      map 'position' => ''
      map 'created_at'
      map 'updated_at'
      map 'adjustment_source_id' => ''
      map 'adjustment_source_type' => ''
    end

    migration.map 'assets' => 'spree_assets'
      map 'id'
      map 'viewable_id'
      map 'viewable_type'
      map 'attachment_content_type'
      map 'attachment_file_name'
      map 'attachment_size'
      map 'position'
      map 'type'
      map 'attachment_updated_at'
      map 'attachment_width'
      map 'attachment_height'
      map 'alt'
    end

    migration.map 'calculators' => 'spree_calculators'
      map 'id'
      map 'type'
      map 'calculable_id'
      map 'calculable_type'
      map 'created_at'
      map 'updated_at'
    end

    migration.map 'checkouts' => ''
      map 'id' => ''
      map 'order_id' => ''
      map 'email' => ''
      map 'ip_address' => ''
      map 'special_instructions' => ''
      map 'bill_address_id' => ''
      map 'created_at' => ''
      map 'updated_at' => ''
      map 'state' => ''
      map 'ship_address_id' => ''
      map 'shipping_method_id' => ''
    end

