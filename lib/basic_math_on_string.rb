def calculate(str)
    numbers_with_sign = str.gsub(/plus|minus/, 'plus' => '+', 'minus' => '-')
    eval(numbers_with_sign).to_s
end
