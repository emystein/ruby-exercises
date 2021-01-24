require 'forwardable'

class Matrix
  include Enumerable
  extend Forwardable # provides def_delegators

  attr_reader :dimensions, :row_count, :column_count, :first_row, :first_column, :last_row, :last_column

  def_delegators :rows, :each

  def initialize(rows)
    @rows = rows

    @first_row = @rows[0] || []
    @first_column = @rows.map { |row| row[0] }

    @row_count = @rows.length
    @column_count = @first_row.length
    @dimensions = RectangularDimensions.new(@row_count, @column_count)

    @last_row = row_slice(@row_count, @row_count).flatten
    @last_column = column_slice(@column_count, @column_count).flatten
  end

  def ==(other)
    flatten == other.flatten
  end

  def area_less_than_or_equal?(rows, columns)
    @dimensions <= RectangularDimensions.new(rows, columns)
  end

  def flatten
    @rows.flatten
  end

  def row_slice(from, to)
    in_range_do(from, to) { @rows[from - 1..to - 1] || [] }
  end

  def column_slice(from, to)
    in_range_do(from, to) { @rows.map { |row| row[from - 1..to - 1] || [] } }
  end

  def transform_using(transformation)
    transformation.apply_to(self)
  end

  def traverse_with(method_of_traversal)
    method_of_traversal.traverse(self)
  end

  private

  def in_range_do(from, to)
    if from >= 1 && from <= to
      yield(from, to)
    else
      []
    end
  end
end

class RectangularDimensions
  include Comparable

  attr_reader :rows, :columns

  def initialize(rows, columns)
    @rows = rows
    @columns = columns
  end

  def area
    @rows * @columns
  end

  def <=>(other)
    area <=> other.area
  end
end

class LeftRightTopDownTraversal
  def traverse(matrix)
    matrix.flatten
  end
end

class SnailClockwiseTraversal
  def traverse(matrix)
    if matrix.area_less_than_or_equal?(1, 1)
      matrix.traverse_with(LeftRightTopDownTraversal.new)
    else
      horizontally_reduced = matrix.transform_using(RemoveHorizontalBorders.new)

      # TODO: traverse DSL (from top left to top right, from top right minus 1 to bottom right, etc.)
      matrix.first_row +
        horizontally_reduced.last_column +
        matrix.last_row.reverse +
        horizontally_reduced.first_column.reverse +
        traverse(matrix.transform_using(RemoveBorders.new))
    end
  end
end

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
    left_slice = LeftColumnSlice.new(@number_of_column_to_remove)
    right_slice = RightColumnSlice.new(@number_of_column_to_remove)

    rows = matrix.transform_using(left_slice).flatten
                 .zip(matrix.transform_using(right_slice).flatten)
                 .map(&:flatten)
                 .map { |cells| cells.filter { |cell| !cell.nil? } }

    Matrix.new(rows)
  end
end

class LeftColumnSlice
  def initialize(number_of_column_limit)
    @number_of_column_limit = number_of_column_limit
  end

  def apply_to(matrix)
    rows = matrix.column_slice(1, @number_of_column_limit - 1)

    Matrix.new(rows)
  end
end

class RightColumnSlice
  def initialize(number_of_column_limit)
    @number_of_column_limit = number_of_column_limit
  end

  def apply_to(matrix)
    rows = matrix.column_slice(@number_of_column_limit + 1, matrix.column_count)

    Matrix.new(rows)
  end
end
