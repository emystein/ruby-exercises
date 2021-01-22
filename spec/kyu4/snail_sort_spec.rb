require 'kyu4/snail_sort'
require 'rspec-parameterized'

describe 'SquareMatrix.snail_sorted' do
  it 'snail snort empty' do
    matrix = SquareMatrix.new([[]])

    expect(matrix.snail_sorted).to eq([])
  end
  it 'snail snort 1 x 1 matrix' do
    matrix = SquareMatrix.new([[1]])

    expect(matrix.snail_sorted).to eq([1])
  end
  it 'snail snort 2 x 2 matrix' do
    matrix = SquareMatrix.new([[1, 2], [3, 4]])

    expect(matrix.snail_sorted).to eq([1, 2, 4, 3])
  end
  it 'snail snort 3 x 3 matrix' do
    matrix = SquareMatrix.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

    expect(matrix.snail_sorted).to eq([1, 2, 3, 6, 9, 8, 7, 4, 5])
  end
  it 'snail snort 4 x 4 matrix' do
    matrix = SquareMatrix.new([[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, 15, 16]])

    expect(matrix.snail_sorted).to eq([1, 2, 3, 4, 8, 12, 16, 15, 14, 13, 9, 5, 6, 7, 11, 10])
  end
end

describe 'SquareMatrix rows and columns' do
  where(:seed, :first_row, :last_row, :middle_first_column, :middle_last_column) do
    [
      [[], [], [], [], []],
      [[[1, 2, 3], [4, 5, 6], [7, 8, 9]], [1, 2, 3], [7, 8, 9], [4], [6]]
    ]
  end

  with_them do
    it 'first row' do
      matrix = SquareMatrix.new(seed)

      expect(matrix.first_row).to eq(first_row)
    end
    it 'last row' do
      matrix = SquareMatrix.new(seed)

      expect(matrix.last_row).to eq(last_row)
    end
    it 'middle first column' do
      matrix = SquareMatrix.new(seed)

      expect(matrix.middle_first_column).to eq(middle_first_column)
    end
    it 'middle last column' do
      matrix = SquareMatrix.new(seed)

      expect(matrix.middle_last_column).to eq(middle_last_column)
    end
    it 'without horizontal borders' do
      matrix = SquareMatrix.new(seed)
      expected = seed[1, seed.length - 2] || []
      expect(matrix.without_horizontal_borders).to eq(SquareMatrix.new(expected))
    end
    it 'without vertical borders' do
      matrix = SquareMatrix.new(seed)
      expected = seed.map { |row| row[1, seed.length - 2] }
      expect(matrix.without_vertical_borders).to eq(SquareMatrix.new(expected))
    end
  end
end

describe 'SquareMatrix.reduced' do
  it 'reduce 3 x 3 matrix to 1 x 1 matrix' do
    matrix = SquareMatrix.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

    expect(matrix.without_borders).to eq(SquareMatrix.new([[5]]))
  end
end
