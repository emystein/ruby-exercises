require 'complete_the_pattern_1'

describe 'pattern' do
    it 'prints empty' do
        expect(pattern(0)).to eq ""
    end

    it 'prints 1' do
        expect(pattern(1)).to eq "1"
    end

    it 'prints up to 2' do
        expect(pattern(2)).to eq "1\n22"
    end

    it 'prints up to 3' do
        expect(pattern(3)).to eq "1\n22\n333"
    end
end