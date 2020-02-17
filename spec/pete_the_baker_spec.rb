require 'pete_the_baker'

describe "Pete the baker" do
    it "can't bake due to missing ingredient" do
        expect(cakes({flour: 500, sugar: 200, eggs: 1}, {flour: 500, sugar: 200})).to eq 0
    end
    it "can't bake due insufficient ingredient" do
        expect(cakes({flour: 500, sugar: 200, eggs: 1}, {flour: 500, sugar: 200, eggs: 0})).to eq 0
    end
    it "can't bake due no ingredients available" do
        expect(cakes({flour: 500, sugar: 200, eggs: 1}, {})).to eq 0
    end
    it "bake with exactly available ingredients for 1 cake" do
        expect(cakes({flour: 500, sugar: 200, eggs: 1}, {flour: 500, sugar: 200, eggs: 1})).to eq 1
    end
    it "bake with exactly available ingredients for 2 cake" do
        expect(cakes({flour: 500, sugar: 200, eggs: 1}, {flour: 1000, sugar: 400, eggs: 2})).to eq 2
    end
    it "bake with available ingredients for more than 2 cake but less than 3 cakes" do
        expect(cakes({flour: 500, sugar: 200, eggs: 1}, {flour: 1000, sugar: 400, eggs: 3})).to eq 2
    end
end