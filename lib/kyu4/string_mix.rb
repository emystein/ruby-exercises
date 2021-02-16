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

  def count_by_letter(letter)
    @count_by_letter[letter] ||= 0
  end

  def letters_diff(other_stats)
    common_letters = letters.union(other_stats.letters)

    letter_diff_factory = LetterOccurrenceDiffFactory.new(self, other_stats)

    common_letters.map { |letter| letter_diff_factory.for(letter) }
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

class LetterOccurrenceDiffFactory
  def initialize(string1_stats, string2_stats)
    @string1_stats = string1_stats
    @string2_stats = string2_stats
  end

  def for(letter)
    if @string1_stats.count_by_letter(letter) > @string2_stats.count_by_letter(letter)
      string_number = '1'
      letter_count = @string1_stats.count_by_letter(letter)
    elsif @string1_stats.count_by_letter(letter) < @string2_stats.count_by_letter(letter)
      string_number = '2'
      letter_count = @string2_stats.count_by_letter(letter)
    else
      string_number = '='
      letter_count = @string1_stats.count_by_letter(letter)
    end

    LetterOccurrenceDiff.new(string_number, letter, letter_count)
  end
end

LetterOccurrenceDiff = Struct.new(:string_number, :letter, :occurrences) {
  def format(format_to_apply)
    format_to_apply.format(self)
  end
}

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
