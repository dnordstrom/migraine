module Migraine
  # Module containing schema generators for different database
  # adapters. To add support for a new adapter, simply add a
  # method such as `database_schema_for_<adapter>`. The method
  # should return a Hash containing table and column hierarchy,
  # as follows:
  #
  # { 
  #   'table' => ['one_column', 'another_column'],
  #   'another_table' => ['one_column']
  # }
  module Generator
    # Generates a new migration file template by analyzing the
    # source and destination connections, saving it to the
    # location specified in the argument. This makes it easy to
    # create migration files where you can fill in destination
    # tables/columns instead of writing it all by hand.
    #
    # TODO: Factor out any dependencies on instance variables
    # such as @source_connection and @destination_connection.
    #
    # @param [String] Relative path to file.
    def generate(file)
      connect
      src = @source_connection
      dest = @destination_connection
      path = File.join(Dir.pwd, File.dirname($0), file)

      File.open(path, 'w') do |file|
        file.puts "require 'migraine'\n\n"
        file.puts "migration = Migraine::Migration.new("
        file.puts "  from: '#{source}',"
        file.puts "  to: '#{destination}'"
        file.puts ")\n\n"
        
        dest_schema = database_schema_for(@destination)
        database_schema_for(@source).each do |table, columns|
          if dest_schema.has_key? table
            file.puts "migration.map '#{table}' do"
          elsif dest_schema.has_key? prefix + table
            file.puts "migration.map '#{table}' => '#{prefix + table}'"
          else
            file.puts "migration.map '#{table}' => ''"
          end
          
          columns.each do |column|
            if !dest_schema[table].nil? && dest_schema[table].include?(column)
              file.puts "  map '#{column}'"
            elsif !dest_schema[prefix + table].nil? &&
                   dest_schema[prefix + table].include?(column)
              file.puts "  map '#{column}'"
            else
              file.puts "  map '#{column}' => ''"
            end
          end

          file.puts "end\n\n"
        end

        file.puts "migration.run"
      end
    end

    # Fetches names of all tables and columns at specified URI
    # (`@source` or `@destination`) and returns them neatly
    # organized hierarchically in an array.
    #
    # @param [String] Database connection string, e.g.
    # 'mysql://root:root@localhost/myproj'.
    def database_schema_for(uri)
      adapter = uri.split(':')[0]
      send("database_schema_for_#{adapter}", uri)
    end
    
    # Generates a database schema for a MySQL database using the
    # available connections/instance variables. We do this by
    # peeking into the information_schema database.
    #
    # @param [String] Database connection string, e.g.
    # 'mysql://root:root@localhost/myproj'.
    def database_schema_for_mysql(uri)
      user_and_db = uri.split('://')[1]
      user_and_host = user_and_db.split('/')[0]
      source_db = user_and_db.split('/')[1]
      schema = {}

      db = Sequel.connect('mysql://' + user_and_host + '/information_schema')
      db[:tables].
        filter(table_schema: source_db).select(:table_name).
        all.each do |record|
          table = record[:table_name]

          columns = db[:columns].
            filter(table_schema: source_db, table_name: table).
            select(:column_name).all.map { |record| record[:column_name] }

          schema.merge!({ table => columns })
        end
      
      schema
    end
  end
end
