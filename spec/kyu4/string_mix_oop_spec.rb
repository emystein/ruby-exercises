require 'kyu4/string_mix_oop'
require 'rspec-parameterized'

describe 'LowercaseStringStats' do
  it 'count by letter' do
    stats = LowercaseStringStats.new('Are they here')

    expect(stats.letter_occurrences('r').occurrences).to eq(2)
    expect(stats.letter_occurrences('e').occurrences).to eq(4)
    expect(stats.letter_occurrences('t').occurrences).to eq(1)
    expect(stats.letter_occurrences('h').occurrences).to eq(2)
    expect(stats.letter_occurrences('y').occurrences).to eq(1)
  end
  it 'compare letter occurrences against other stats' do
    stats1 = LowercaseStringStats.new('aaabbc')
    stats2 = LowercaseStringStats.new('aab')

    result = stats1.compare_occurrences_of('a', stats2)

    expect(result).to eq(MaximumInString1.new('a', LetterOccurrences.new('a', 3)))
  end
end

describe 'StringCompare' do
  it 'get letters in common between strings' do
    compare = StringCompare.new

    result = compare.diff_with_min_occurrences('Are they here', 'yes, they are here', 2)

    expect(result.letters).=~ %w[r e h y]
  end
  it 'format letters and occurrences' do
    compare = StringCompare.new

    result = compare.diff_with_min_occurrences('Are they here', 'yes, they are here', 2)

    expect(result.sort_by(LetterRepetitionsDescendingOrder.new).format(JoinStringNumberAndLetterRepetitions.new)).to eq '2:eeeee/2:yy/=:hh/=:rr'
  end
end

describe 'string_mix' do
  where(:string1, :string2, :expected) do
    [
      ['looping is fun but dangerous', 'less dangerous than coding', '1:ooo/1:uuu/2:sss/=:nnn/1:ii/2:aa/2:dd/2:ee/=:gg'],
      ['In many languages', "there's a pair of functions", '1:aaa/1:nnn/1:gg/2:ee/2:ff/2:ii/2:oo/2:rr/2:ss/2:tt'],
      ['Lords of the Fallen', 'gamekult', '1:ee/1:ll/1:oo'],
      ['codewars', 'codewars', ''],
      ['A generation must confront the looming ', 'codewarrs', '1:nnnnn/1:ooooo/1:tttt/1:eee/1:gg/1:ii/1:mm/=:rr']
    ]
  end

  with_them do
    it 'mix' do
      expect(mix(string1, string2)).to eq(expected)
    end
  end
end