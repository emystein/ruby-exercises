require "divisors"

describe "Divisors" do
    it "return [2,3,4,6] as divisors of 12" do
        expect(divisors(12)).to eq [2,3,4,6]  
    end
    it "return number if it is prime" do
      expect(divisors(13)).to eq "13 is prime"  
    end
    it "return [3,5] as divisors of 15" do
        expect(divisors(15)).to eq [3,5]
    end
    it "return [5] as divisors of 25" do
        expect(divisors(25)).to eq [5]
    end
end
