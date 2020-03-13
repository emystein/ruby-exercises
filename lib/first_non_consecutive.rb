# https://www.codewars.com/kata/58f8a3a27a5c28d92e000144
def first_non_consecutive(arr)
    if arr.length < 2
        nil
    end

    arr.select.with_index{ |e, i| 
        (0 < i && i < arr.length && arr[i] != arr[i - 1] + 1) 
    }.first
end
