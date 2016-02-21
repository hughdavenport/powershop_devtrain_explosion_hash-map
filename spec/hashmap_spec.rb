require 'HashMap'

RSpec.describe HashMap do

    describe "When I create a new hashmap" do
        context "with no arguments" do
            before do
                @map = HashMap.new
            end
            it "should be empty" do
                expect(@map).to be_empty
            end
            it "should have a weight of 0.8" do
                expect(@map.weight).to eq 0.8
            end
            it "should have a size of 0" do
                expect(@map.size).to eq 0
            end
            it "should have an underlying size of 10" do
                expect(@map.underlying_size).to eq 10
            end
        end
    end

    describe "When I add elements" do
        context "To a new map" do
            before do
                @map = HashMap.new
                @map.put("test", "value")
            end
            it "should return the correct value for that key" do
                expect(@map.get("test")).to eq "value"
            end
            it "should replace the value when adding the same key" do
                @map.put("test", "value2")
                expect(@map.get("test")).to eq "value2"
            end
            it "should not be present when deleted" do
                @map.delete("test")
                expect(@map.get("test")).to be_nil
            end
        end
    end

end
