# https://www.codewars.com/kata/51e056fe544cf36c410000fb
def top_3_words(text)
  WordCount.new(text).top(3)
end

class WordCount
  attr_reader :by_word

  def initialize(text)
    words = text.split(' ').map { |characters| Word.new(characters) }.filter(&:not_empty?)
    @by_word = Hash.new(0)
    words.each { |word| @by_word[word.to_s] += 1 }
  end

  def sorted
    first_value_from_pairs(sorted_by_value(@by_word))
  end

  def top(count)
    sorted.reverse.first(count)
  end

  private

  def first_value_from_pairs(pairs)
    pairs.map { |pair| pair[0] }
  end

  def sorted_by_value(hash)
    hash.sort { |a, b| a[1] <=> b[1] }
  end
end

class Word
  def initialize(text)
    @string = filter_word(text).downcase
  end

  def to_s
    @string
  end

  def size
    @string.size
  end

  def not_empty?
    size.positive?
  end

  private

  def filter_word(text)
    text[/\w+'?t?/] || ''
  end
end

