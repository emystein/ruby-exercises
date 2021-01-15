require 'kyu4/top_3_words'

describe 'WordCount' do
  it 'count words in single line text' do
    expect(WordCount.new('a').by_word).to eq({ 'a' => 1 })
    expect(WordCount.new('a b').by_word).to eq({ 'a' => 1, 'b' => 1 })
    expect(WordCount.new('a a').by_word).to eq({ 'a' => 2 })
    expect(WordCount.new('a a b').by_word).to eq({ 'a' => 2, 'b' => 1 })
    expect(WordCount.new('a a b b').by_word).to eq({ 'a' => 2, 'b' => 2 })
  end
  it 'sorted' do
    expect(WordCount.new('a a a b b c').sorted).to eq(%w[c b a])
  end
  it 'top 3 words' do
    expect(WordCount.new('a').top(3)).to eq ['a']
    expect(WordCount.new('a b').top(3)).to eq %w[b a]
    expect(WordCount.new('a b c').top(3)).to eq %w[c b a]
    expect(WordCount.new('a a b c').top(3)).to eq %w[a c b]
    expect(WordCount.new('a b b c').top(3)).to eq %w[b c a]
    expect(WordCount.new('a b c c').top(3)).to eq %w[c b a]
  end
end

describe 'Word' do
  it 'filters only letters' do
    expect(Word.new('ab.c.d,;').to_s).to eq 'abcd'
  end
  it 'size' do
    expect(Word.new('smooth').size).to be 6
  end
end

