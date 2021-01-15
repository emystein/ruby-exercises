require 'kyu4/top_3_words'
require 'rspec-parameterized'

describe 'WordCount' do
  where(:text, :count_by_word, :top_three) do
    [
      ['a', { 'a' => 1 }, %w[a]],
      ['a b', { 'a' => 1, 'b' => 1 }, %w[b a]],
      ['a a', { 'a' => 2 }, %w[a]],
      ['a a b', { 'a' => 2, 'b' => 1 }, %w[a b]],
      ['a b b', { 'a' => 1, 'b' => 2 }, %w[b a]],
      ['a a b b', { 'a' => 2, 'b' => 2 }, %w[b a]],
      ['a b c', { 'a' => 1, 'b' => 1, 'c' => 1 }, %w[c b a]],
      ['a a b c', { 'a' => 2, 'b' => 1, 'c' => 1 }, %w[a c b]],
      ['a b b c', { 'a' => 1, 'b' => 2, 'c' => 1 }, %w[b c a]],
      ['a b c c', { 'a' => 1, 'b' => 1, 'c' => 2 }, %w[c b a]]
    ]
  end

  with_them do
    it 'count words in single line text' do
      expect(WordCount.new(text).by_word).to eq count_by_word
    end
    it 'top 3 words' do
      expect(WordCount.new(text).top(3)).to eq top_three
    end
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

