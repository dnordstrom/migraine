require 'minitest/autorun'
require 'migraine'

module SpecHelper
  def create_test_connections_for(migration)
    migration.instance_variable_set(
      :@source_connection,
      Sequel.sqlite
    )
    migration.instance_variable_get(:@source_connection).
      create_table :old_table do
        String :old_column
      end
    
    migration.instance_variable_set(
      :@destination_connection,
      Sequel.sqlite
    )
    migration.instance_variable_get(:@destination_connection).
      create_table :new_table do
        String :new_column
      end

    migration.instance_variable_get(:@source_connection)[:old_table].
      insert(old_column: 'some text string')
  end
end
