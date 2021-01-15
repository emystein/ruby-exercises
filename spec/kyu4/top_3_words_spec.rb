require 'kyu4/top_3_words'

describe 'Top3Words' do
  it 'top 3 words' do
    expect(top_3_words('a')).to eq ['a']
    expect(top_3_words('b')).to eq ['b']
    expect(top_3_words('a b')).to eq %w[a b]
    expect(top_3_words('a b c')).to eq %w[a b c]
    expect(top_3_words('a a b c')).to eq %w[a b c]
  end
end

describe 'count words' do
  it 'count words in single line text' do
    expect(count_words('a')).to eq({ 'a' => 1 })
    expect(count_words('a b')).to eq({ 'a' => 1, 'b' => 1 })
    expect(count_words('a a')).to eq({ 'a' => 2 })
    expect(count_words('a a b')).to eq({ 'a' => 2, 'b' => 1 })
    expect(count_words('a a b b')).to eq({ 'a' => 2, 'b' => 2 })
  end
end

describe 'sorted by value' do
  it 'sort' do
    expect(sorted_by_value({ 'a' => 1 })).to eq [['a', 1]]
    expect(sorted_by_value({ 'a' => 1, 'b' => 1, 'c' => 1 })).to eq [['a', 1], ['b', 1], ['c', 1]]
    expect(sorted_by_value({ 'a' => 1, 'b' => 1, 'c' => 2 })).to eq [['a', 1], ['b', 1], ['c', 2]]
    expect(sorted_by_value({ 'a' => 1, 'b' => 2, 'c' => 2 })).to eq [['a', 1], ['b', 2], ['c', 2]]
    expect(sorted_by_value({ 'a' => 1, 'b' => 2, 'c' => 1 })).to eq [['a', 1], ['c', 1], ['b', 2]]
    expect(sorted_by_value({ 'a' => 2, 'b' => 1, 'c' => 1 })).to eq [['b', 1], ['c', 1], ['a', 2]]
    expect(sorted_by_value({ 'a' => 3, 'b' => 1, 'c' => 2 })).to eq [['b', 1], ['c', 2], ['a', 3]]
    expect(sorted_by_value({ 'a' => 3, 'b' => 2, 'c' => 1 })).to eq [['c', 1], ['b', 2], ['a', 3]]
  end
end

describe 'get first value from pairs' do
  it 'get first values from non-empty array' do
    expect(first_value_from_pairs([['a', 1], ['b', 1], ['c', 1]])).to eq(%w[a b c])
  end
  it 'get no values from empty array' do
    expect(first_value_from_pairs([])).to eq []
  end
end

