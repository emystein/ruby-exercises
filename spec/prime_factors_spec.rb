require 'prime_factors'

describe 'Primes in numbers' do
  it 'factors out 2 as (2)' do
    expect(prime_factors(2)).to eq '(2)'
  end
  it 'factors out 4 as (2**2)' do
    expect(prime_factors(4)).to eq '(2**2)'
  end
  it 'factors out 6 as (2)(3)' do
    expect(prime_factors(6)).to eq '(2)(3)'
  end
  it 'factors out 8 as (2**3)' do
    expect(prime_factors(8)).to eq '(2**3)'
  end
  it 'factors out 12 as (2**2)(3)' do
    expect(prime_factors(12)).to eq '(2**2)(3)'
  end
  it 'factors out 36 as (2**2)(3**2)' do
    expect(prime_factors(36)).to eq '(2**2)(3**2)'
  end
end
