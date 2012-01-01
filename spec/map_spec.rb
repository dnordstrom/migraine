require 'spec_helper'

describe Migraine::Map do
  describe "#new" do
    before do
      @map = Migraine::Map.new(
        from: "one_location",
        to: "another_location"
      )
    end

    it "should set the source to map from" do
      @map.source.must_equal "one_location"
    end

    it "should set the destination to map to" do
      @map.destination.must_equal "another_location"
    end
  end
end
