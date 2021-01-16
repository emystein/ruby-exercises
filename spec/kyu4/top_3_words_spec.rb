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
      ['a b c c', { 'a' => 1, 'b' => 1, 'c' => 2 }, %w[c b a]],
      ['a a a  b  c c  d d d d  e e e e e', { 'a' => 3, 'b' => 1, 'c' => 2, 'd' => 4, 'e' => 5 }, %w[e d a]],
      ['e e e e DDD ddd DdD: ddd ddd aa aA Aa, bb cc cC e e e', { 'e' => 7, 'ddd' => 5, 'aa' => 3, 'bb' => 1, 'cc' => 2 }, %w[e ddd aa]],
      ['  //wont won\'t won\'t ', { 'wont' => 1, 'won\'t' => 2 }, %w[won't wont]],
      ['  , e   .. ', { 'e' => 1 }, %w[e]],
      ['  ...  ', {}, []],
      ['  \'  ', {}, []],
      ['  \'\'\'  ', {}, []],
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

  it 'count top 3 words in multiline' do
    text = """In a village of La Mancha, the name of which I have no desire to call to
mind, there lived not long since one of those gentlemen that keep a lance
in the lance-rack, an old buckler, a lean hack, and a greyhound for
coursing. An olla of rather more beef than mutton, a salad on most
nights, scraps on Saturdays, lentils on Fridays, and a pigeon or so extra
on Sundays, made away with three-quarters of his income."""

    expect(WordCount.new(text).top(3)).to eq %w[a of on]
  end
end

describe 'Word' do
  it 'case insensitive' do
    expect(Word.new('AbCd').to_s).to eq 'abcd'
  end
  it 'filters only letters' do
    expect(Word.new('ab.c.d,;').to_s).to eq 'ab'
  end
  it 'size' do
    expect(Word.new('smooth').size).to be 6
  end
end

