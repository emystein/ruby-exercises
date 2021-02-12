require 'kyu5/pick_peaks'
require 'rspec-parameterized'

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
