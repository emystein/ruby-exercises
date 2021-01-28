class RemoveBorders
  def apply_to(matrix)
    matrix.transform_using(RemoveHorizontalBorders.new)
          .transform_using(RemoveVerticalBorders.new)
  end
end

class RemoveHorizontalBorders
  def apply_to(matrix)
    rows = matrix.row_slice(2, matrix.row_count - 1)

    Matrix.new(rows)
  end
end

class RemoveVerticalBorders
  def apply_to(matrix)
    rows = matrix.column_slice(2, matrix.column_count - 1)

    Matrix.new(rows)
  end
end

class RemoveColumnNumbered
  def initialize(number_of_column_to_remove)
    @number_of_column_to_remove = number_of_column_to_remove
  end

  def apply_to(matrix)
    left_slice = LeftSideColumnSlice.new(@number_of_column_to_remove)
    right_slice = RightSideColumnSlice.new(@number_of_column_to_remove)

    rows = matrix.transform_using(left_slice).flatten
                 .zip(matrix.transform_using(right_slice).flatten)
                 .map { |cells| cells.filter { |cell| !cell.nil? } }

    Matrix.new(rows)
  end
end

class LeftSideColumnSlice
  def initialize(number_of_column_limit)
    @number_of_column_limit = number_of_column_limit
  end

  def apply_to(matrix)
    rows = matrix.column_slice(1, @number_of_column_limit - 1)

    Matrix.new(rows)
  end
end

class RightSideColumnSlice
  def initialize(number_of_column_limit)
    @number_of_column_limit = number_of_column_limit
  end

  def apply_to(matrix)
    rows = matrix.column_slice(@number_of_column_limit + 1, matrix.column_count)

    Matrix.new(rows)
  end
end
