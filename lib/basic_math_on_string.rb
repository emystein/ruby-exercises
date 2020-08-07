# https://www.codewars.com/kata/5809b62808ad92e31b000031
def calculate(string)
  numbers_with_sign = string.gsub(/plus|minus/, 'plus' => '+', 'minus' => '-')
  eval(numbers_with_sign).to_s
end
