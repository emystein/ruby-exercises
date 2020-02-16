def anagrams(word, words)
    sorted_word = word.chars.sort
    words.select{|word| word.chars.sort == sorted_word} 
end