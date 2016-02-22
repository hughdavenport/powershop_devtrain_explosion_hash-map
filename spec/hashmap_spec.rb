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
            context "after adding different" do
                before do
                    @map.put("another test", "another value")
                end
                it "should have the original key still" do
                    expect(@map.get("test")).to eq "value"
                end
                it "should return the new value" do
                    expect(@map.get("another test")).to eq "another value"
                end
                it "should have a size of 2" do
                    expect(@map.size).to eq 2
                end
                it "should have the original key present in keys" do
                    expect(@map.keys).to include "test"
                end
                it "should have the new key present in keys" do
                    expect(@map.keys).to include "another test"
                end
                it "should have the original value present in values" do
                    expect(@map.values).to include "value"
                end
                it "should have the new value present in values" do
                    expect(@map.values).to include "another value"
                end
                it "should have 2 key(s)" do
                    expect(@map.keys.length).to eq 2
                end
                it "should have 2 value(s)" do
                    expect(@map.values.length).to eq 2
                end
            end
        end
        context "to a map just before need for reweighting" do
            before do
                @map = HashMap.new
                # Should have a weight of 8, and underlying_size of 10, so can add 7 items
                (1..7).each{|i| @map.put("#{i}test#{i}", "value#{i}") }
            end
            it "should have a underlying size of 10" do
                expect(@map.underlying_size).to eq 10
            end
            it "should have a size of 7" do
                expect(@map.size).to eq 7
            end
            it "should have a keys size of 7" do
                expect(@map.keys.length).to eq 7
            end
            it "should have a values size of 7" do
                expect(@map.values.length).to eq 7
            end
            it "should be under the reweighting threshold" do
                expect(@map.underlying_size * @map.weight).to be > @map.size
            end
            context "adding one more" do
                before do
                    @map.put("test8", "value8")
                end
                it "should be under the reweight threshold" do
                    expect(@map.underlying_size * @map.weight).to be > @map.size
                end
                it "should have grown the underlying size" do
                    expect(@map.underlying_size).to be > 10
                end
                it "should have a size of 8" do
                    expect(@map.size).to eq 8
                end
                it "should have a keys size of 8" do
                    expect(@map.keys.length).to eq 8
                end
                it "should have a values size of 8" do
                    expect(@map.values.length).to eq 8
                end
            end
        end
        context "adding a large amount of keys" do
            before do
                @map = HashMap.new
                (0..99).each {|i| @map.put("#{i}test#{i}", "value#{i}")}
            end
            it "should have a size of 100" do
                expect(@map.size).to eq 100
            end
            it "should have 100 keys" do
                expect(@map.keys.length).to eq 100
            end
            it "should be able to retrieve all values" do
                (0..99).each do |i|
                    expect(@map.get("#{i}test#{i}")).to eq "value#{i}"
                end
            end
            it "should have not need reweighting" do
                expect(@map.size).to be < (@map.underlying_size * @map.weight)
            end
            it "should be able to delete all values" do
                (0..99).each do |i|
                    expect(@map.delete("#{i}test#{i}")).to eq "value#{i}"
                end
            end
            context "after deleting all values" do
                before do
                    (0..99).each{|i| @map.delete("#{i}test#{i}")}
                end
                it "should be empty" do
                    expect(@map).to be_empty
                end
                it "should have no keys" do
                    expect(@map.keys).to be_empty
                end
                it "should have a size of 0" do
                    expect(@map.size).to eq 0
                end
                it "should not return valid result for any keys" do
                    (0..99).each do |i|
                        expect(@map.get("#{i}test#{i}")).to be_nil
                    end
                end
            end
        end
        context "adding larger amount of keys" do
            before do
                @map = HashMap.new
                (0..999).each{|i| @map.put("#{i}test#{i}", "value#{i}")}
            end
            it "should have a average number of operations below 2" do
                expect(@map.average_get_operations).to be < 2.0
            end
        end
    end

end
