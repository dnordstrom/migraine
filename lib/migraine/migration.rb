module Migraine
  # This is a special case of a `Migraine::Map` as it specifies
  # source and destination *databases* and provides methods to,
  # for example, run the migration. It also overrides
  # Migraine::Map#set_source_and_destination_from(s_and_d) to
  # accept surce and destination in a more elegant way.
  class Migration < Map
    include Migraine::Generator

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

    def log(message)
      print "\n#{message}\n"
    end
  end
end
