# https://www.codewars.com/kata/54bf1c2cd5b56cc47f0007a1
def duplicate_count(text)
  counts = Hash.new(0)
  text.downcase.chars.each { |c| counts[c] += 1 }
  counts.values.count { |v| v > 1 }
end
