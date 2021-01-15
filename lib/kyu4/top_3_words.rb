# https://www.codewars.com/kata/51e056fe544cf36c410000fb
def top_3_words(text)
  sorted_by_value(first_value_from_pairs(count_words(text))).first(3)
end

def count_words(text)
  count_by_word = Hash.new(0)

  text.split(' ').each { |word| count_by_word[word] += 1 }

  count_by_word
end

def first_value_from_pairs(pairs)
  pairs.map { |pair| pair[0] }
end

def sorted_by_value(hash)
  hash.sort { |a, b| a[1] <=> b[1] }
end


