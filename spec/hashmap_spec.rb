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
            it "should return nil when getting a key" do
                expect(@map.get("test")).to be_nil
            end
        end
    end

    describe "When I add elements" do
        context "to a new map" do
            before do
                @map = HashMap.new
                @map.put("test", "value")
            end
            it "should return the correct value for that key" do
                expect(@map.get("test")).to eq "value"
            end
            it "should return the correct value when deleting" do
                expect(@map.delete("test")).to eq "value"
            end
            it "should return the old value when replacing" do
                expect(@map.put("test", "value2")).to eq "value"
            end
            it "should have the key present in keys" do
                expect(@map.keys).to include "test"
            end
            it "should have the value present in values" do
                expect(@map.values).to include "value"
            end
            it "should have size of 1" do
                expect(@map.size).to eq 1
            end
            it "should have 1 key(s)" do
                expect(@map.keys.length).to eq 1
            end
            it "should have 1 value(s)" do
                expect(@map.values.length).to eq 1
            end
            it "should not be empty" do
                expect(@map).not_to be_empty
            end
            context "after adding duplicate" do
                before do
                    @map.put("test", "value2")
                end
                it "should replace the value when adding the same key" do
                    expect(@map.get("test")).to eq "value2"
                end
                it "should have a size of 1 still" do
                    expect(@map.size).to eq 1
                end
                it "should have the key present in keys" do
                    expect(@map.keys).to include "test"
                end
                it "should have the new value present in values" do
                    expect(@map.values).to include "value2"
                end
                it "should have 1 key(s) still" do
                    expect(@map.keys.length).to eq 1
                end
                it "should have 1 value(s) still" do
                    expect(@map.values.length).to eq 1
                end
            end
            context "after deleting" do
                before do
                    @map.delete("test")
                end
                it "should not have value present" do
                    expect(@map.get("test")).to be_nil
                end
                it "should be empty" do
                    expect(@map).to be_empty
                end
                it "should have a size of 0" do
                    expect(@map.size).to eq 0
                end
                it "should not have the key in the keys array" do
                    expect(@map.keys).not_to include "test"
                end
                it "should have 0 key(s)" do
                    expect(@map.keys.length).to eq 0
                end
                it "should have 1 value(s)" do
                    expect(@map.values.length).to eq 0
                end
            end
        end
    end

end
