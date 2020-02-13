def divisors(n)
  divs = (2..(n / 2)).select { |d| n.modulo(d) == 0 }
  divs.empty? ? "#{n} is prime" : divs
end
