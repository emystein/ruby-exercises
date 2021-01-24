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
  end

  describe 'Columns left to a column' do
    it 'columns left to the first column' do
      matrix = Matrix.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

      expect(matrix.columns_left_to(1)).to eq([])
    end
    it 'columns left to the second column' do
      matrix = Matrix.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

      expect(matrix.columns_left_to(2)).to eq([[1], [4], [7]])
    end
    it 'columns left to the last column' do
      matrix = Matrix.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

      expect(matrix.columns_left_to(matrix.column_count)).to eq([[1, 2], [4, 5], [7, 8]])
    end
  end

  describe 'Columns right to a column' do
    it 'columns right to the first column' do
      matrix = Matrix.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

      expect(matrix.columns_right_to(1)).to eq([[2, 3], [5, 6], [8, 9]])
    end
    it 'columns right to the second column' do
      matrix = Matrix.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

      expect(matrix.columns_right_to(2)).to eq([[3], [6], [9]])
    end
    it 'columns right to the last column' do
      matrix = Matrix.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

      expect(matrix.columns_right_to(matrix.column_count)).to eq([])
    end
  end

  describe 'Row Slice' do
    where(:from, :to, :expected) do
      [
        [0, 0, []],
        [0, 1, []],
        [1, 0, []],
        [1, 1, [[1, 2, 3]]],
        [1, 2, [[1, 2, 3], [4, 5, 6]]],
        [1, 3, [[1, 2, 3], [4, 5, 6], [7, 8, 9]]],
        [1, 4, [[1, 2, 3], [4, 5, 6], [7, 8, 9]]],
        [2, 0, []],
        [2, 1, []],
        [2, 2, [[4, 5, 6]]],
        [2, 3, [[4, 5, 6], [7, 8, 9]]],
        [3, 3, [[7, 8, 9]]]
      ]
    end
    with_them do
      it 'from x to y' do
        matrix = Matrix.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

        expect(matrix.row_slice(from, to)).to eq(expected)
      end
    end
  end

  describe 'Column Slice' do
    where(:from, :to, :expected) do
      [
        [0, 0, []],
        [0, 1, []],
        [1, 0, []],
        [1, 1, [[1], [4], [7]]],
        [1, 2, [[1, 2], [4, 5], [7, 8]]],
        [1, 3, [[1, 2, 3], [4, 5, 6], [7, 8, 9]]],
        [1, 4, [[1, 2, 3], [4, 5, 6], [7, 8, 9]]],
        [2, 0, []],
        [2, 1, []],
        [2, 2, [[2], [5], [8]]],
        [2, 3, [[2, 3], [5, 6], [8, 9]]],
        [3, 3, [[3], [6], [9]]],
      ]
    end
    with_them do
      it 'from x to y' do
        matrix = Matrix.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

        expect(matrix.column_slice(from, to)).to eq(expected)
      end
    end
  end
end

describe 'Matrix reduce' do
  it 'reduce 3 x 3 matrix to 1 x 1 matrix' do
    matrix = Matrix.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

    expect(RemoveBorders.new.apply_to(matrix)).to eq(Matrix.new([[5]]))
  end

  describe 'Horizontal borders' do
    where(:seed, :expected) do
      [
        [[], []],
        [[[1]], []],
        [[[1, 2]], []],
        [[[1], [2]], []],
        [[[1, 2], [3, 4]], []],
        [[[1, 2, 3], [4, 5, 6], [7, 8, 9]], [[4, 5, 6]]]
      ]
    end

    with_them do
      it 'remove horizontal borders' do
        matrix = Matrix.new(seed)

        expect(RemoveHorizontalBorders.new.apply_to(matrix)).to eq(Matrix.new(expected))
      end
    end
  end

  describe 'Vertical borders' do
    where(:seed, :expected) do
      [
        [[], []],
        [[[1]], []],
        [[[1, 2]], []],
        [[[1], [2]], []],
        [[[1, 2], [3, 4]], []],
        [[[1, 2, 3], [4, 5, 6], [7, 8, 9]], [[2], [5], [8]]],
      ]
    end

    with_them do
      it 'remove vertical borders' do
        matrix = Matrix.new(seed)

        expect(RemoveVerticalBorders.new.apply_to(matrix)).to eq(Matrix.new(expected))
      end
    end
  end

  describe 'Remove Column numbered' do
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
      remove_last_column = RemoveColumnNumbered.new(matrix.column_count)

      expect(matrix.transform_using(remove_last_column)).to eq(Matrix.new([[1, 2], [4, 5], [7, 8]]))
    end
  end
end
