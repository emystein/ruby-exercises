# https://www.codewars.com/kata/515de9ae9dcfc28eb6000001
def solution(str)
  str << '_' if str.length.odd?
  str.chars.each_slice(2).map(&:join)
end
