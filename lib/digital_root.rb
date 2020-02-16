# https://www.codewars.com/kata/541c8630095125aba6000c00
def digital_root(n)
    n < 10 ? n : digital_root(n.digits.sum)
end
