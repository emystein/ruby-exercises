# https://www.codewars.com/kata/52b305bec65ea40fe90007a7
def grabscrab(anagram, dictionary)
    sorted_anagram = anagram.chars.sort
    dictionary.select{|w| w.chars.sort == sorted_anagram}
end