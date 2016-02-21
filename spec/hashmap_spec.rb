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

end
