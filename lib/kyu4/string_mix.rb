# https://www.codewars.com/kata/5629db57620258aa9d000014

def mix(string1, string2)
  string1_stats = string_stats_with_mininum_occurrences(string1, 2)
  string2_stats = string_stats_with_mininum_occurrences(string2, 2)
  format_occurrences(
    sort_merged_stats(
      merged_stats_by_letter_occurrence(
        merge_stats(string1_stats, '1', string2_stats, '2')
      )
    )
  )
end

def string_stats_with_mininum_occurrences(string, letter_minimum_occurrences)
  filter_mininum_occurrences(string_stats(string), letter_minimum_occurrences)
end

def string_stats(string)
  string.chars
        .select { |c| c.match(/[[:lower:]]/) }
        .group_by(&:downcase)
        .transform_values(&:size)
end

def filter_mininum_occurrences(stats, letter_minimum_occurrences)
  stats.select { |letter, occurrences| occurrences >= letter_minimum_occurrences }
end

def merge_stats(stats1, string_number1, stats2, string_number2)
  letters = (stats1.keys + stats2.keys).uniq

  Hash[
    letters.map do |letter|
      occurrences_in_string1 = stats1[letter] || 0
      occurrences_in_string2 = stats2[letter] || 0

      maximum = ['=', occurrences_in_string1]

      if occurrences_in_string1 > occurrences_in_string2
        maximum = [string_number1, occurrences_in_string1]
      elsif occurrences_in_string1 < occurrences_in_string2
        maximum = [string_number2, occurrences_in_string2]
      end

      [letter, maximum]
    end
  ]
end

def merged_stats_by_letter_occurrence(merged_stats)
  by_letter_occurrence = {}

  merged_stats.each do |letter, v|
    pair = [v[0], letter]

    if by_letter_occurrence.key?(v[1])
      by_letter_occurrence[v[1]] << pair
    else
      by_letter_occurrence[v[1]] = [pair]
    end
  end

  by_letter_occurrence.transform_values(&:sort)
end

def sort_merged_stats(merged_stats)
  sort_by_letter_occurrence(merged_stats).flat_map do |occurrence, string_number_and_letter|
    string_number_and_letter.sort.map { |v| v.append(occurrence) }
  end
end

def sort_by_letter_occurrence(merged_stats)
  merged_stats.to_a.sort.reverse
end

def format_occurrences(occurrences)
  occurrences.map { |s| "#{s[0]}:#{s[1] * s[2]}" }.join('/')
end