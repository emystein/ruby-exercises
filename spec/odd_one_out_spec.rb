require "odd_one_out"

describe "character last position and count" do
    it "register unique position and count 1" do
        expect(position_and_count("H", "Hello World")).to eq PositionAndCount.new("H", 0, 1)
    end

    it "register last position and count 2" do
        expect(position_and_count("o", "Hello World")).to eq PositionAndCount.new("o", 7, 2)
    end

    it "register last position and count 3" do
        expect(position_and_count("l", "Hello World")).to eq PositionAndCount.new("l", 9, 3)
    end
end

describe "odd one out" do
   it "leaves no out in empty string" do
       expect(odd_one_out("")).to eq []
    end
    it "leaves out odd characters in 'Hellow World'" do
        expect(odd_one_out("Hello World")).to eq ["H", "e", " ", "W", "r", "l", "d"]
   end
end
