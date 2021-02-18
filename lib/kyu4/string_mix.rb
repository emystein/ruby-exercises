# https://www.codewars.com/kata/5629db57620258aa9d000014

def mix(string1, string2)
  occurrences1 = string_stats(string1)
  occurrences2 = string_stats(string2)

  letters = (occurrences1.keys + occurrences2.keys).uniq

  maximum_occurrences = {}

  letters.each do |letter|
    letter_occurrences = maximum_occurrences(letter, occurrences1, occurrences2)

    if letter_occurrences.occurrences >= 2
      maximum_occurrences[letter_occurrences.occurrences] ||= []
      maximum_occurrences[letter_occurrences.occurrences] << letter_occurrences
    end
  end

  result = maximum_occurrences.transform_values(&:sort)
                              .to_a.sort.reverse
                              .flat_map { |_occurrences, letter_occurrences_in_string| letter_occurrences_in_string }

  result.map(&:to_s).join('/')
end

def string_stats(string)
  stats = string.chars
                .select { |c| c.match(/[[:lower:]]/) }
                .group_by(&:downcase)
                .transform_values(&:size)

  stats.default = 0

  stats
end

def maximum_occurrences(letter, occurrences1, occurrences2)
  if occurrences1[letter] > occurrences2[letter]
    LetterOccurrenceInString.new(occurrences1[letter], '1', letter)
  elsif occurrences1[letter] < occurrences2[letter]
    LetterOccurrenceInString.new(occurrences2[letter], '2', letter)
  else
    LetterOccurrenceInString.new(occurrences1[letter], '=', letter)
  end
end

class LetterOccurrenceInString
  attr_reader :occurrences, :string_number, :letter

  def initialize(occurrences, string_number, letter)
    @occurrences = occurrences
    @string_number = string_number
    @letter = letter
  end

  def <=>(other)
    [@occurrences, @string_number, @letter] <=> [other.occurrences, other.string_number, other.letter]
  end

  def to_s
    "#{@string_number}:#{@letter * @occurrences}"
  end
end
