# https://www.codewars.com/kata/58f8a3a27a5c28d92e000144
def first_non_consecutive(arr)
    arr.select.with_index{ |e, i| (i.between?(1, arr.length) && arr[i] != arr[i - 1] + 1) }.first || nil
end
