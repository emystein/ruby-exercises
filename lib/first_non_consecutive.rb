# https://www.codewars.com/kata/58f8a3a27a5c28d92e000144
def first_non_consecutive(array)
  array.each_cons(2) { |a, b| return b if b - a > 1 }
end
