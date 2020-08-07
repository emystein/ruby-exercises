# https://www.codewars.com/kata/5572f7c346eb58ae9c000047
def pattern(number)
  (1..number).map { |x| x.to_s * x }.join("\n")
end
