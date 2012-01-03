module Migraine
  # This is a special case of a `Migraine::Map` as it specifies
  # source and destination *databases* and provides methods to,
  # for example, run the migration. It also overrides
  # Migraine::Map#set_source_and_destination_from(s_and_d) to
  # accept surce and destination in a more elegant way.
  class Migration < Map
    attr_accessor :prefix

    # Runs the migration using the mappings that have been set
    # up. Walks through the nested Map objects, copying database
    # records from source to destination.
    def run
      connect
      src = @source_connection
      dest = @destination_connection

      log "BEGINNING MIGRATION\n" +
          "-------------------"

      # Iterate through table mappings
      maps.each do |table|
        log "MIGRATING TABLE #{table.source}"

        # Fetch all rows from source table
        rows = src[table.source.to_sym].all
        
        # Iterate through the records and migrate each one
        rows.each do |row|
          new_record = {}

          # Identify the columns we need to grab data from
          table.maps.each do |column|
            new_record.merge!(
              column.destination.to_sym => row[column.source.to_sym]
            )
          end

          # Insert new record to destination table
          log " -> Inserting record into #{table.destination}"
          dest[table.destination.to_sym].insert(new_record)
        end
      end

      log "-------------------\n" +
          "MIGRATION COMPLETED"
    end

    # Generates a new migration file template by analyzing the
    # source and destination connections, saving it to the
    # location specified in the argument. This makes it easy to
    # create migration files where you can fill in destination
    # tables/columns instead of writing it all by hand.
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

    # DSL convenience method for skipping the assignment operator
    # when specifying prefix.
    #
    # @param [String] Prefix to use in generations.
    def prefix(new_prefix = nil)
      return @prefix if new_prefix.nil?
      @prefix = new_prefix
    end

    private
    
    # Sets the `@source` and `@destination` instance variables
    # from a Hash containing :to and :from keys. Raises
    # ArgumentError unless a proper Hash is provided.
    #
    # @param [Hash] Hash containing source and destination.
    def set_source_and_destination_from(s_and_d)
      if !s_and_d.is_a? Hash || s_and_d.length != 2
        raise ArgumentError, "Argument must be a Hash containing two elements;
          source (:from) and destination (:to)."
      elsif !s_and_d[:from] || !s_and_d[:to]
        raise ArgumentError, "Both source (:from) and destination (:to)
          need to be specified."
      end

      @source = s_and_d[:from]
      @destination = s_and_d[:to]
    end

    # Uses `@source` and `@destination` variables to initialize
    # database connections. If source or destination is specified
    # using a 'test://' URI, a `Sequel.sqlite` test database is
    # used as connection.
    def connect
      unless @source && @destination
        raise RuntimeError, 'Source and destination are not specified.'
      end

      return if @source_connection && @destination_connection
      
      if @source =~ /^test:\/\//
        @source_connection = Sequel.sqlite
      else
        @source_connection = Sequel.connect(@source)
      end
      
      if @destination =~ /^test:\/\//
        @destination_connection = Sequel.sqlite
      else
        @destination_connection = Sequel.connect(@destination)
      end
    end

    # Fetches names of all tables and columns at specified URI
    # (`@source` or `@destination`) and returns them neatly
    # organized hierarchically in an array.
    def database_schema_for(uri)
      adapter = uri.split(':')[0]
      send("database_schema_for_#{adapter}", uri)
    end
    
    # Generates a database schema for a MySQL database using the
    # available connections/instance variables. We do this by
    # peeking into the information_schema database.
    def database_schema_for_mysql(uri)
      user_and_db = uri.split('://')[1]
      user_and_host = user_and_db.split('/')[0]
      source_db = user_and_db.split('/')[1]
      tables = {}

      db = Sequel.connect('mysql://' + user_and_host + '/information_schema')
      db[:tables].
        filter(table_schema: source_db).select(:table_name).
        all.each do |record|
          table = record[:table_name]

          columns = db[:columns].
            filter(table_schema: source_db, table_name: table).
            select(:column_name).all.map { |record| record[:column_name] }

          tables.merge!({ table => columns })
        end
      
      tables
    end

    def log(message)
      print "\n#{message}\n"
    end
  end
end
