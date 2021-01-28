require 'kyu4/snail_sort'
require 'grid_coordinates'
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

  describe 'Slices' do
    matrix = Matrix.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

    where(:from, :to, :expected_row_slice, :expected_column_slice) do
      [
        [0, 0, [], []],
        [0, 1, [], []],
        [1, 0, [], []],
        [1, 1, [[1, 2, 3]], [[1], [4], [7]]],
        [1, 2, [[1, 2, 3], [4, 5, 6]], [[1, 2], [4, 5], [7, 8]]],
        [1, 3, [[1, 2, 3], [4, 5, 6], [7, 8, 9]], [[1, 2, 3], [4, 5, 6], [7, 8, 9]]],
        [1, 4, [[1, 2, 3], [4, 5, 6], [7, 8, 9]], [[1, 2, 3], [4, 5, 6], [7, 8, 9]]],
        [2, 0, [], []],
        [2, 1, [], []],
        [2, 2, [[4, 5, 6]], [[2], [5], [8]]],
        [2, 3, [[4, 5, 6], [7, 8, 9]], [[2, 3], [5, 6], [8, 9]]],
        [3, 3, [[7, 8, 9]], [[3], [6], [9]]]
      ]
    end

    with_them do
      it 'Row Slice' do
        expect(matrix.row_slice(from, to)).to eq(expected_row_slice)
      end
      it 'Column Slice' do
        expect(matrix.column_slice(from, to)).to eq(expected_column_slice)
      end
    end
  end
end

describe 'Matrix reduce' do
  it 'reduce 3 x 3 matrix to 1 x 1 matrix' do
    matrix = Matrix.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

    expect(RemoveBorders.new.apply_to(matrix)).to eq(Matrix.new([[5]]))
  end

  describe 'Borders' do
    where(:seed, :without_horizontal_borders, :without_vertical_borders) do
      [
        [[], [], []],
        [[[1]], [], []],
        [[[1, 2]], [], []],
        [[[1], [2]], [], []],
        [[[1, 2], [3, 4]], [], []],
        [[[1, 2, 3], [4, 5, 6], [7, 8, 9]], [[4, 5, 6]], [[2], [5], [8]]]
      ]
    end

    with_them do
      it 'remove horizontal borders' do
        matrix = Matrix.new(seed)

        expect(RemoveHorizontalBorders.new.apply_to(matrix)).to eq(Matrix.new(without_horizontal_borders))
      end
      it 'remove vertical borders' do
        matrix = Matrix.new(seed)

        expect(RemoveVerticalBorders.new.apply_to(matrix)).to eq(Matrix.new(without_vertical_borders))
      end
    end
  end

  describe 'Remove Column numbered' do
    matrix = Matrix.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

    where(:number_of_column_to_remove, :expected_removed) do
      [
        [1, []],
        [2, [[1, 3], [4, 6], [7, 9]]],
        [3, [[1, 2], [4, 5], [7, 8]]]
      ]
    end

    with_them do
      it 'remove' do
        remove_column = RemoveColumnNumbered.new(number_of_column_to_remove)

        expect(matrix.transform_using(remove_column)).to eq(Matrix.new(expected_removed))
      end
    end
  end

  describe 'Left and right column slices' do
    matrix = Matrix.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

    where(:column_number, :columns_to_the_left, :columns_to_the_right) do
      [
        [1, [], [[2, 3], [5, 6], [8, 9]]],
        [2, [[1], [4], [7]], [[3], [6], [9]]],
        [3, [[1, 2], [4, 5], [7, 8]], []]
      ]
    end

    with_them do
      it 'columns left to the column' do
        slice = LeftSideColumnSlice.new(column_number)

        expect(matrix.transform_using(slice)).to eq(Matrix.new(columns_to_the_left))
      end
      it 'columns right to the column' do
        slice = RightSideColumnSlice.new(column_number)

        expect(matrix.transform_using(slice)).to eq(Matrix.new(columns_to_the_right))
      end
    end
  end
end
