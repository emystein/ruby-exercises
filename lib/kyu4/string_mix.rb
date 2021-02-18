# https://www.codewars.com/kata/5629db57620258aa9d000014

def mix(string1, string2)
  letter_minimum_occurrences = 2

  format_occurrences(
    sort_merged_stats(
      merge_stats(string1, '1', string2, '2', letter_minimum_occurrences)
    )
  )
end

def string_stats(string)
  string.chars
        .select { |c| c.match(/[[:lower:]]/) }
        .group_by(&:downcase)
        .transform_values(&:size)
end

def merge_stats(string1, string_number1, string2, string_number2, minimum_occurrences)
  stats1 = string_stats(string1)
  stats2 = string_stats(string2)
  letters = (stats1.keys + stats2.keys).uniq

  by_occurrences = {}

  letters.each do |letter|
    occurrences_of_letter = stats1[letter] || 0
    occurrences_in_string2 = stats2[letter] || 0
    string_number = '='

    if occurrences_of_letter > occurrences_in_string2
      string_number = string_number1
    elsif occurrences_of_letter < occurrences_in_string2
      occurrences_of_letter = occurrences_in_string2
      string_number = string_number2
    end

    if occurrences_of_letter >= minimum_occurrences
      by_occurrences[occurrences_of_letter] ||= []
      by_occurrences[occurrences_of_letter] << [string_number, letter]
    end
  end

  by_occurrences.transform_values(&:sort)
end

def sort_merged_stats(merged_stats)
  sort_by_letter_occurrence(merged_stats).reverse.flat_map do |occurrence, string_number_and_letter|
    string_number_and_letter.sort.map { |v| LetterOccurrenceInString.new(v[0], v[1], occurrence) }
  end
end

def sort_by_letter_occurrence(merged_stats)
  merged_stats.to_a.sort
end

def format_occurrences(occurrences)
  occurrences.map do |occurrence|
    "#{occurrence.string_number}:#{occurrence.letter * occurrence.occurrences}"
  end.join('/')
end

LetterOccurrenceInString = Struct.new(:string_number, :letter, :occurrences)
