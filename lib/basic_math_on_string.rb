# https://www.codewars.com/kata/5809b62808ad92e31b000031
def calculate(str)
    numbers_with_sign = str.gsub(/plus|minus/, 'plus' => '+', 'minus' => '-')
    eval(numbers_with_sign).to_s
end
