# https://www.codewars.com/kata/541c8630095125aba6000c00
def digital_root(number)
  number < 10 ? number : digital_root(number.digits.sum)
end
