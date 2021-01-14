# https://www.codewars.com/kata/513e08acc600c94f01000001
def rgb(r, g, b)
  "#{to_hex(r)}#{to_hex(g)}#{to_hex(b)}"
end

def to_hex(number)
  [[0, number].max, 255].min.to_s(16).rjust(2, '0').upcase
end

