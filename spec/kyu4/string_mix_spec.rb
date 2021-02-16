require 'kyu4/string_mix'
require 'rspec-parameterized'

describe 'StringStats' do
  it 'count by letter' do
    stats = StringStats.new('Are they here')

    expect(stats.count).to eq({'a' => 1, 'r' => 2, 'e' => 4, 't' => 1, 'h' => 2, 'y' => 1})
  end
  it 'count by letter with minimum occurrences' do
    stats = StringStats.new('Are they here')

    expect(stats.count_with_min(2)).to eq({'r' => 2, 'e' => 4, 'h' => 2})
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

    expect(result.format(StringNumberAndLetterRepetitionsFormat.new)).to eq '2:eeeee/2:yy/=:hh/=:rr'
  end
end
