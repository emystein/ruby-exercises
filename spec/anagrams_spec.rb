require 'anagrams'

describe "Anagrams" do
    it "find anagrams of abba" do
        expect(anagrams('abba', ['aabb', 'abcd', 'bbaa', 'dada'])).to eq ['aabb', 'bbaa']
    end
end
