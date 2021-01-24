require 'kyu4/snail_sort'
require 'rspec-parameterized'

describe 'SnailClockwiseTraversal' do
  where(:seed, :expected) do
    [
      [[[]], []],
      [[[1]], [1]],
      [[[1, 2], [3, 4]], [1, 2, 4, 3]],
      [[[1, 2], [3, 4], [5, 6]], [1, 2, 4, 6, 5, 3]],
      [[[1, 2, 3], [4, 5, 6]], [1, 2, 3, 6, 5, 4]],
      [[[1, 2, 3], [4, 5, 6], [7, 8, 9]], [1, 2, 3, 6, 9, 8, 7, 4, 5]],
      [[[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, 15, 16]], [1, 2, 3, 4, 8, 12, 16, 15, 14, 13, 9, 5, 6, 7, 11, 10]]
    ]
  end

  with_them do
    it 'snail sort' do
      traversal = SnailClockwiseTraversal.new

      matrix = Matrix.new(seed)

      expect(traversal.traverse(matrix)).to eq(expected)
    end
  end
end

describe 'Matrix rows and columns' do
  where(:seed, :first_row, :last_row) do
    [
      [[], [], []],
      [[[1, 2, 3], [4, 5, 6], [7, 8, 9]], [1, 2, 3], [7, 8, 9]]
    ]
  end

  with_them do
    it 'first row' do
      matrix = Matrix.new(seed)

      expect(matrix.first_row).to eq(first_row)
    end
    it 'last row' do
      matrix = Matrix.new(seed)

      expect(matrix.last_row).to eq(last_row)
    end
    it 'remove horizontal borders' do
      matrix = Matrix.new(seed)
      expected = seed[1, seed.length - 2] || []
      expect(RemoveHorizontalBorders.new.apply_to(matrix)).to eq(Matrix.new(expected))
    end
    it 'remove vertical borders' do
      matrix = Matrix.new(seed)
      expected = seed.map { |row| row[1, seed.length - 2] }
      expect(RemoveVerticalBorders.new.apply_to(matrix)).to eq(Matrix.new(expected))
    end
  end
end

describe 'Matrix reduce' do
  it 'reduce 3 x 3 matrix to 1 x 1 matrix' do
    matrix = Matrix.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

    expect(RemoveBorders.new.apply_to(matrix)).to eq(Matrix.new([[5]]))
  end

  it 'columns before first column' do
    matrix = Matrix.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

    expect(matrix.columns_before(1)).to eq([])
  end
  it 'columns before second column' do
    matrix = Matrix.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

    expect(matrix.columns_before(2)).to eq([[1], [4], [7]])
  end
  it 'columns before last column' do
    matrix = Matrix.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

    expect(matrix.columns_before(matrix.last_column_number)).to eq([[1, 2], [4, 5], [7, 8]])
  end

  it 'columns after first column' do
    matrix = Matrix.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

    expect(matrix.columns_after(1)).to eq([[2, 3], [5, 6], [8, 9]])
  end
  it 'columns after second column' do
    matrix = Matrix.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

    expect(matrix.columns_after(2)).to eq([[3], [6], [9]])
  end
  it 'columns after last column' do
    matrix = Matrix.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

    expect(matrix.columns_after(matrix.last_column_number)).to eq([])
  end
end

describe 'Remove Column' do
  matrix = Matrix.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

  it 'first' do
    remove_column1 = RemoveColumnNumbered.new(1)

    expect(matrix.transform_using(remove_column1)).to eq(Matrix.new([]))
  end
  it 'second' do
    remove_column2 = RemoveColumnNumbered.new(2)

    expect(matrix.transform_using(remove_column2)).to eq(Matrix.new([[1, 3], [4, 6], [7, 9]]))
  end
  it 'last' do
    remove_last_column = RemoveColumnNumbered.new(matrix.last_column_number)

    expect(matrix.transform_using(remove_last_column)).to eq(Matrix.new([[1, 2], [4, 5], [7, 8]]))
  end
end
