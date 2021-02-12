require 'kyu5/pick_peaks'
require 'rspec-parameterized'

describe 'Blocks with neighbours' do
  where(:input, :expected) do
    [
      [[], []],
      [[1], []],
      [[1, 2], []],
      [[1, 2, 3], [[2]]],
      [[1, 2, 3, 4], [[2], [3]]],
      [[1, 2, 2, 3], [[2, 2]]],
    ]
  end

  with_them do
    it 'empty when input is not enough long' do
      expect(blocks_with_neighbours(input)).to eq(expected)
    end
  end
end

describe 'Same first elements grouped' do
  where(:input, :expected) do
    [
      [[], []],
      [[1], [[1]]],
      [[1, 2], [[1], [2]]],
      [[1, 1], [[1, 1]]],
      [[1, 1, 2], [[1, 1], [2]]]
    ]
  end

  with_them do
    it 'empty when input is not enough long' do
      expect(same_first_elements_grouped(input)).to eq(expected)
    end
  end
end

describe 'Reduced duplicates' do
  where(:input, :expected) do
    [
      [[], []],
      [[1], [1]],
      [[1, 2], [1, 2]],
      [[1, 1], [1]],
      [[1, 1, 2], [1, 2]]
    ]
  end

  with_them do
    it 'reduce' do
      expect(reduce_duplicates(input)).to eq(expected)
    end
  end
end

describe 'Pick Peaks' do
  where(:input, :expected_pos, :expected_peaks) do
    [
      [[], [], []],
      [[1], [], []],
      [[1, 1], [], []],
      [[1, 2], [], []],
      [[2, 1], [], []],
      [[1, 1, 1], [], []],
      [[1, 1, 2], [], []],
      [[2, 1, 1], [], []],
      [[2, 2, 1], [], []],
      [[1, 2, 1], [1], [2]],
      [[3, 2, 3, 6, 4, 1, 2, 3, 2, 1, 2, 3], [3, 7], [6, 3]],
      [[1, 2, 2, 1], [1], [2]],
      [[2, 1, 3, 1, 2, 2, 2, 2], [2], [3]]
    ]
  end

  with_them do
    it 'pick peaks' do
      expected = { 'pos' => expected_pos, 'peaks' => expected_peaks }

      expect(pick_peaks(input)).to eq(expected)
    end
  end
end
