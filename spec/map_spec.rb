require 'spec_helper'

describe Migraine::Map do
  before do
    @map = Migraine::Map.new('old_location' => 'new_location')
  end

  describe "#new" do
    it 'should set the source to map from' do
      @map.source.must_equal 'old_location'
    end

    it 'should set the destination to map to' do
      @map.destination.must_equal 'new_location'
    end

  end

  describe '#set_source_and_destination_from' do
    it 'should raise ArgumentError on invalid argument' do
      begin
        @map.send(:set_source_and_destination_from,
          this: 'is not', a: 'valid argument'
        )
      rescue ArgumentError
        raised = true
      end

      raised.wont_be_nil
    end
  end

  describe '#map' do
    it "should store new Migraine::Map instance" do
      @map.map 'old_location' => 'new_location'
      @map.maps.length.must_equal 1
    end

    it "should accept a block for use as DSL" do
      @map.maps = [] # Clear maps added by other tests

      @map.map 'old_table' => 'new_table' do
        map 'old_olumn' => 'new_column'
      end

      @map.maps[0].maps.length.must_equal 1
    end

    it "should accept string argument" do
      @map.maps = []
      @map.map 'unchanged'
      @map.maps[0].destination.must_equal 'unchanged'
    end
  end
end
