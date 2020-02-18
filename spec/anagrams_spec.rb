require 'anagrams'

describe "Anagrams" do
    it "find anagrams of abba" do
        expect(anagrams('abba', ['aabb', 'abcd', 'bbaa', 'dada'])).to eq ['aabb', 'bbaa']
    end
    it 'filter all out' do
        expect(anagrams("ourf", ["one","two","three"])).to eq []
    end
end
