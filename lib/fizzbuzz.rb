def fizzbuzz(number)
    result = multiple_to_string(number, 3, 'fizz')
    result += multiple_to_string(number, 5, 'buzz')
    result.empty? ? number.to_s : result
end

def multiple_to_string(multiple, number, string)
    multiple.modulo(number) == 0 ? string : ''
end