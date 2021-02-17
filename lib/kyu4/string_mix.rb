# https://www.codewars.com/kata/5629db57620258aa9d000014

def mix(string1, string2)
  letter_minimum_occurrences = 2

  string1_stats =
    filter_minimum_occurrences(string_stats(string1), letter_minimum_occurrences)
  string2_stats =
    filter_minimum_occurrences(string_stats(string2), letter_minimum_occurrences)

  format_occurrences(
    sort_merged_stats(
      merge_stats(string1_stats, '1', string2_stats, '2')
    )
  )
end

def string_stats(string)
  string.chars
        .select { |c| c.match(/[[:lower:]]/) }
        .group_by(&:downcase)
        .transform_values(&:size)
end

def filter_minimum_occurrences(stats, letter_minimum_occurrences)
  stats.select { |letter, occurrences| occurrences >= letter_minimum_occurrences }
end

def merge_stats(stats1, string_number1, stats2, string_number2)
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

    by_occurrences[occurrences_of_letter] ||= []
    by_occurrences[occurrences_of_letter] << [string_number, letter]
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
