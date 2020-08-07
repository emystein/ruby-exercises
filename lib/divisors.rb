# https://www.codewars.com/kata/544aed4c4a30184e960010f4
def divisors(number)
  divs = (2..(number / 2)).select { |d| number.modulo(d).zero? }
  divs.empty? ? "#{number} is prime" : divs
end
