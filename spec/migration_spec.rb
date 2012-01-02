require 'spec_helper'

include SpecHelper

describe Migraine::Migration do
  before do
    @migration = Migraine::Migration.new(
      from: 'test://myproj_old.db',
      to: 'test://myproj.db'
    )
  end

  describe "#new" do
    it 'should set the source database' do
      @migration.source.must_equal 'test://myproj_old.db'
    end

    it 'should set the destination to map to' do
      @migration.destination.must_equal 'test://myproj.db'
    end
  end

  describe '#set_source_and_destination_from' do
    it 'should raise ArgumentError on invalid argument' do
      begin
        @migration.send(:set_source_and_destination_from,
          'this is a Map argument' => 'Migration uses :to and :from'
        )
      rescue ArgumentError
        raised = true
      end

      raised.wont_be_nil
    end
  end

  describe '#connect' do
    it "should initialize a database connections" do
      @migration.send(:connect)
      @migration.instance_variable_get(:@source_connection).
        wont_be_nil
    end
  end

  describe '#run' do
    it "should run the migration" do
      @migration = Migraine::Migration.new(from: 'test', to: 'test')
      @migration.map 'old_table' => 'new_table' do
        map 'old_column' => 'new_column'
      end

      create_test_connections_for(@migration)

      @migration.run

      # Check that new column now has one record, which was
      # migrated from the source (inserted into source by
      # `create_test_connections_for` helper).
      @migration.instance_variable_get(
        :@destination_connection)[:new_table].
        count.must_equal 1
    end
  end
end
