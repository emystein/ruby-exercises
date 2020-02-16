# https://www.codewars.com/kata/523a86aa4230ebb5420001e1
def anagrams(word, words)
    sorted_word = word.chars.sort
    words.select{|word| word.chars.sort == sorted_word} 
end