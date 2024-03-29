# https://www.codewars.com/kata/5629db57620258aa9d000014

def mix(string1, string2)
  compare = StringCompare.new

  result = compare.diff_with_min_occurrences(string1, string2, 2)

  result.sort_by(LetterRepetitionsDescendingOrder.new)
        .format(JoinStringNumberAndLetterRepetitions.new)
end

class LowercaseStringStats
  def initialize(string)
    @count_by_letter = string.chars
                             .filter { |c| c.match(/[[:lower:]]/) }
                             .group_by(&:downcase)
                             .transform_values(&:size)
  end

  def letters
    @count_by_letter.keys
  end

  def letter_occurrences(letter)
    occurrences = @count_by_letter[letter] ||= 0

    LetterOccurrences.new(letter, occurrences)
  end

  def letters_diff(other_stats)
    common_letters = letters.union(other_stats.letters)

    common_letters.map { |letter| compare_occurrences_of(letter, other_stats) }
  end

  def compare_occurrences_of(letter, stats_compared)
    if letter_occurrences(letter).greater?(stats_compared)
      LetterOccurrenceDiff.maximumInString1(letter_occurrences(letter))
    elsif letter_occurrences(letter).less?(stats_compared)
      LetterOccurrenceDiff.maximumInString2(stats_compared.letter_occurrences(letter))
    else
      LetterOccurrenceDiff.sameOccurrenesInBothStrings(letter_occurrences(letter))
    end
  end
end

class LetterOccurrences
  attr_reader :letter, :occurrences

  def initialize(letter, occurrences)
    @letter = letter
    @occurrences = occurrences
  end

  def ==(other)
    @letter == other.letter && @occurrences == other.occurrences
  end

  def greater?(stats_compared)
    @occurrences > stats_compared.letter_occurrences(@letter).occurrences
  end

  def less?(stats_compared)
    @occurrences < stats_compared.letter_occurrences(@letter).occurrences
  end
end

class StringCompare
  def diff_with_min_occurrences(string1, string2, min_occurrences)
    string1_stats = LowercaseStringStats.new(string1)
    string2_stats = LowercaseStringStats.new(string2)

    letters_diff = string1_stats.letters_diff(string2_stats)

    StringDiff.new(letters_diff.filter { |letter_diff| letter_diff.occurrences >= min_occurrences })
  end
end

class StringDiff
  def initialize(diff)
    @letter_diffs = diff
  end

  def letters
    @letter_diffs.map(&:letter)
  end

  def sort_by(order_to_apply)
    @letter_diffs = order_to_apply.sort(@letter_diffs)
    self
  end

  def format(format_to_apply)
    format_to_apply.format(@letter_diffs)
  end
end

class LetterOccurrenceDiff
  attr_reader :string_number, :letter, :occurrences

  def self.maximumInString1(letter_occurrences)
    LetterOccurrenceDiff.new('1', letter_occurrences)
  end

  def self.maximumInString2(letter_occurrences)
    LetterOccurrenceDiff.new('2', letter_occurrences)
  end

  def self.sameOccurrenesInBothStrings(letter_occurrences)
    LetterOccurrenceDiff.new('=', letter_occurrences)
  end

  def initialize(string_number, letter_occurrences)
    @string_number = string_number
    @letter = letter_occurrences.letter
    @occurrences = letter_occurrences.occurrences
  end

  def ==(other)
    @string_number == other.string_number &&
      @letter == other.letter &&
      @occurrences == other.occurrences
  end

  def format(format_to_apply)
    format_to_apply.format(self)
  end
end

class JoinStringNumberAndLetterRepetitions
  def format(elements)
    elements.map { |element| element.format(StringNumberAndLetterRepetitions.new) }.join('/')
  end
end

class StringNumberAndLetterRepetitions
  def format(letter_diff)
    "#{letter_diff.string_number}:#{letter_diff.letter * letter_diff.occurrences}"
  end
end

class LetterRepetitionsDescendingOrder
  def sort(diff)
    by_occurrences = diff.group_by(&:occurrences)

    occurrences_desc = by_occurrences.keys.sort.reverse

    occurrences_desc.flat_map do |occurrences|
      by_occurrences[occurrences].sort_by do |letter_diff|
        letter_diff.format(StringNumberAndLetterRepetitions.new)
      end
    end
  end
end
