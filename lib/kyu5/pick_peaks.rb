# https://www.codewars.com/kata/5279f6fe5ab7f447890006a7

def blocks_with_neighbours(array)
  if array.size >= 3
    same_first_elements_grouped(array[1..array.size - 2])
  else
    []
  end
end

def same_first_elements_grouped(array)
  result = []

  until array.empty?
    first_same_elements = array.take_while { |element| element == array.first }

    result << first_same_elements

    array = array.drop(first_same_elements.size)
  end

  result
end

def reduce_duplicates(array)
  same_first_elements_grouped(array).flat_map(&:uniq)
end

def pick_peaks(array)
  pos = []
  peaks = []

  if array.size > 2
    (1..array.size - 2).each do |i|
      if local_maxima?(array, i)
        pos << i
        peaks << array[i]
      end
    end
  end

  { pos: pos, peaks: peaks }
end

def local_maxima?(array, index)
  last_index = index

  while array[index] == array[index + 1]
    last_index += 1
  end

  array[index - 1] < array[index] && array[last_index] > array[last_index + 1]
end
