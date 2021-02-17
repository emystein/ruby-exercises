require 'kyu4/string_mix'
require 'rspec-parameterized'

describe 'string mix' do
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

describe 'string stats' do
  it 'calculate stats' do
    expect(string_stats('aabbbc')).to eq({ 'a' => 2, 'b' => 3, 'c' => 1 })
  end
  it 'filter stats by letter minimum occurrences' do
    expect(filter_mininum_occurrences(string_stats('aabbbc'), 2)).to eq({ 'a' => 2, 'b' => 3 })
  end
  it 'calculate stats with mininmum occurrences' do
    expect(string_stats_with_mininum_occurrences('aabbbc', 2)).to eq({ 'a' => 2, 'b' => 3 })
  end
end

describe 'merge string stats' do
  where(:stats1, :stats2, :expected) do
    [
      [{ 'a' => 1 }, {}, { 'a' => ['1', 1] }],
      [{}, { 'a' => 1 }, { 'a' => ['2', 1] }],
      [{ 'a' => 1 }, { 'b' => 1 }, { 'a' => ['1', 1], 'b' => ['2', 1] }],
      [{ 'a' => 1 }, { 'a' => 1 }, { 'a' => ['=', 1] }],
      [{ 'a' => 2 }, { 'a' => 1 }, { 'a' => ['1', 2] }],
      [{ 'a' => 1 }, { 'a' => 2 }, { 'a' => ['2', 2] }],
      [{ 'a' => 1, 'b' => 1 }, { 'a' => 2, 'b' => 2 }, { 'a' => ['2', 2], 'b' => ['2', 2] }],
      [{ 'a' => 2, 'b' => 2 }, { 'a' => 1, 'b' => 1 }, { 'a' => ['1', 2], 'b' => ['1', 2] }]
    ]
  end

  with_them do
    it 'merge' do
      expect(merge_stats(stats1, '1', stats2, '2')).to eq(expected)
    end
  end
end

describe 'merged string stats by occurrence' do
  where(:stats, :expected) do
    [
      [{ 'a' => ['1', 1] }, { 1 => [%w[1 a]] }],
      [{ 'a' => ['1', 1], 'b' => ['1', 3] }, { 3 => [%w[1 b]], 1 => [%w[1 a]] }],
      [{ 'a' => ['1', 2], 'b' => ['2', 2], 'c' => ['=', 1] }, { 2 => [%w[1 a], %w[2 b]], 1 => [%w[= c]] }],
      [{ 'b' => ['2', 2], 'a' => ['1', 2], 'c' => ['=', 1] }, { 2 => [%w[1 a], %w[2 b]], 1 => [%w[= c]] }],
      [{ 'b' => ['2', 2], 'c' => ['=', 1], 'a' => ['1', 2] }, { 2 => [%w[1 a], %w[2 b]], 1 => [%w[= c]] }]
    ]
  end

  with_them do
    it 'transform merged' do
      expect(merged_stats_by_letter_occurrence(stats)).to eq(expected)
    end
  end
end

describe 'strings diffs' do
  where(:merged_stats, :expected) do
    [
      [{ 3 => [%w[2 b], %w[1 a]], 2 => [%w[= c]] }, [['1', 'a', 3], ['2', 'b', 3], ['=', 'c', 2]]]
    ]
  end

  with_them do
    it 'sort' do
      expect(sort_merged_stats(merged_stats)).to eq(expected)
    end
  end

  it 'format' do
    expect(format_occurrences([['1', 'a', 3], ['2', 'b', 3], ['=', 'c', 2]])).to eq('1:aaa/2:bbb/=:cc')
  end
end
