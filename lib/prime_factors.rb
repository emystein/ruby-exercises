require 'prime'

# https://www.codewars.com/kata/54d512e62a5e54c96200019e
def prime_factors(number)
  factors = number.prime_division
  factors.map { |p, e| e == 1 ? "(#{p})" : "(#{p}**#{e})" }.join
end
