# https://www.codewars.com/kata/51e056fe544cf36c410000fb
def top_3_words(text)
  WordCount.new(text).top(3)
end

class WordCount
  attr_reader :by_word

  def initialize(text)
    words = text.split(' ').map { |characters| Word.new(characters) }.filter(&:not_empty?)
    @by_word = words.group_by(&:to_s).transform_values(&:size)
  end

  def sorted
    @by_word.sort_by { |_, v| v }.map { |k, _| k }
  end

  def top(count)
    sorted.reverse.first(count)
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

