require 'prime_factors'

describe "Primes in numbers" do
    it "factors out 2 as (2)" do
        expect(primeFactors(2)).to eq '(2)'
    end
    it "factors out 4 as (2**2)" do
        expect(primeFactors(4)).to eq '(2**2)'
    end
    it "factors out 6 as (2)(3)" do
        expect(primeFactors(6)).to eq '(2)(3)'
    end
    it "factors out 8 as (2**3)" do
        expect(primeFactors(8)).to eq '(2**3)'
    end
    it "factors out 12 as (2**2)(3)" do
        expect(primeFactors(12)).to eq '(2**2)(3)'
    end
    it "factors out 36 as (2**2)(3**2)" do
        expect(primeFactors(36)).to eq '(2**2)(3**2)'
    end
end
