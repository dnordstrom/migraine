module Migraine
  class Migration
    # Specify source and destination databases. Argument should
    # be a Hash containing :to and :from keys, specifying
    # database connection URLs, e.g.:
    #
    # migration = Migraine::Migration.new(
    #   from: "mysql://root:root@localhost/myproj_old",
    #   to:   "mysql://root:root@localhost/myproj"
    # )
    #
    # @param [Hash] Hash containing source and destination.
    def initialize(databases)
      begin
        set_source_and_destination_from(databases)
      rescue ArgumentError => e
        puts e.message
        exit
      end
    end

    # Sets the `@source` and `@destination` instance variables
    # from a Hash containing :to and :from keys. Raises
    # ArgumentError unless a proper Hash is provided.
    #
    # @param [Hash] Hash containing source and destination.
    def set_source_and_destination_from(databases)
      if !databases.is_a? Hash || databases.length !== 2
        raise ArgumentError, "Argument must be a Hash containing two elements;
          source (:from) and destination (:to) databases."
      elsif databases[:from] || databases[:to]
        raise ArgumentError, "Both source (:from) and destination (:to)
          databases need to be specified."
      end

      @source = databases[:from]
      @destination = databases[:to]
    end
  end
end
