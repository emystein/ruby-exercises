# https://www.codewars.com/kata/5629db57620258aa9d000014

class StringStats
  def initialize(string)
    @string = string
    count
  end

  def count
    @letter_count = @string.chars
                           .filter { |c| c != ' ' }
                           .group_by(&:downcase)
                           .transform_values(&:size)

    @letter_count
  end

  def letter_count(letter)
    @letter_count[letter]
  end

  def letters
    @letter_count.keys
  end

  def count_with_min(min)
    @string.chars
           .filter { |c| c != ' ' }
           .group_by(&:downcase)
           .transform_values(&:size)
           .filter { |_k, v| v >= min }
  end

  def letters_diff(other_stats)
    common_letters = letters.intersection(other_stats.letters)

    letter_diff_factory = LetterOccurrenceDiffFactory.new(self, other_stats)

    common_letters.map { |letter| letter_diff_factory.for(letter) }
  end
end

class StringCompare
  def diff_with_min_occurrences(string1, string2, min_occurrences)
    string1_stats = StringStats.new(string1)
    string2_stats = StringStats.new(string2)

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
    if @string1_stats.letter_count(letter) > @string2_stats.letter_count(letter)
      string_number = 1
      letter_count = @string1_stats.letter_count(letter)
    elsif @string1_stats.letter_count(letter) < @string2_stats.letter_count(letter)
      string_number = 2
      letter_count = @string2_stats.letter_count(letter)
    else
      string_number = '='
      letter_count = @string1_stats.letter_count(letter)
    end

    LetterOccurrenceDiff.new(string_number, letter, letter_count)
  end
end

LetterOccurrenceDiff = Struct.new(:string_number, :letter, :occurrences)

class StringNumberAndLetterRepetitions
  def format(diff)
    sorted(diff).map { |d| "#{d.string_number}:#{d.letter * d.occurrences}" }.join('/')
  end

  def sorted(diff)
    diff.sort { |a, b| a.occurrences <=> b.occurrences }.reverse
  end
end
