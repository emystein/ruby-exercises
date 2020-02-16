# https://www.codewars.com/kata/544aed4c4a30184e960010f4
def divisors(n)
  divs = (2..(n / 2)).select { |d| n.modulo(d) == 0 }
  divs.empty? ? "#{n} is prime" : divs
end
