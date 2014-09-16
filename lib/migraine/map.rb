module Migraine
  class Map
    attr_accessor :source
    attr_accessor :destination
    attr_accessor :maps

    # Sets the source and destination to use for mapping. Takes a
    # Hash containing a single element as argument, where key
    # specifies source and value specifies destination.
    #
    # This constructor should not be used publicly, but rather
    # through the `Migraine::Map#map` DSL method which adds
    # instances to the @maps array.
    #
    #     Migraine::Map.new 'source_table' => 'destination_table'
    #
    # @param [Hash] Hash containing source and destination.
    def initialize(source_and_destination)
      begin
        set_source_and_destination_from(source_and_destination)
      rescue ArgumentError => e
        puts e.message
        exit
      end
    end

    # Adds a new map to the @maps array. In other words, maps an
    # old location to a new location one level below the current,
    # be it at database, table or column level. This lets us have
    # nested Maps, using the same class for any 'level'.
    #
    # For example, if the current source and destination are
    # databases, this will map a source table to a destination
    # table within that database. If current is a table, it will
    # map column names.
    #
    # It accepts a block as optional argument, which will be
    # evaluated against the new Map instance so that `#map` calls
    # can be nested using a more convenient DSL.
    #
    # Usage in migration/mapping DSL:
    #
    #     # Map#map at database-level, mapping table names
    #     @migration.map 'source_table' => 'destination_table' do
    #       # Map#map at table-level, mapping column names
    #       map 'source_column' => 'destination_column'
    #     end
    def map(source_and_destination, &block)
      @maps ||= []
      map = Migraine::Map.new(source_and_destination)
      
      if block_given?
        map.instance_eval(&block)
      end

      @maps << map
    end

    private
    
    # Sets the `@source` and `@destination` instance variables
    # from argument. Argument can be either a String (when source
    # has the same name as destination) or a Hash (where both
    # source and destination need to be specified.)
    #
    # Raises ArgumentError unless source and destination is
    # properly defined in a Hash argument.
    #
    # @param [Hash] Hash containing source and destination.
    def set_source_and_destination_from(s_and_d)
      # If String is provided, convert it to Hash
      s_and_d = { s_and_d => s_and_d } if s_and_d.is_a? String

      unless s_and_d.is_a?(Hash) && s_and_d.length === 1
        raise ArgumentError, "Argument must be a Hash containing one element;
          source as key, destination as value."
      end

      s_and_d.each do |source, destination|
        @source = source
        @destination = destination
      end
    end
  end
end
