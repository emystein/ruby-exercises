require 'anagrams'

describe 'Anagrams' do
  it 'find anagrams of abba' do
    expect(anagrams('abba', %w[aabb abcd bbaa dada])).to eq %w[aabb bbaa]
  end
  it 'filter all out' do
    expect(anagrams('ourf', %w[one two three])).to eq []
  end
end
