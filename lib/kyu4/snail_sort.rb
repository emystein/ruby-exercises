require 'forwardable'

class Matrix
  include Enumerable
  extend Forwardable # provides def_delegators

  attr_reader :rows, :dimensions, :max_row_index, :max_column_index, :first_column_number, :last_column_number

  def_delegators :rows, :each

  def initialize(rows)
    @rows = rows
    @dimensions = RectangularDimensions.new(@rows.length, @rows.length)
    @max_row_index = @rows.length - 1
    @first_row = @rows[0] || []
    @max_column_index = @first_row.length - 1
    @last_column_number = @first_row.length
  end

  def ==(other)
    @rows == other.rows
  end

  def area_less_than_or_equal?(rows, columns)
    @dimensions <= RectangularDimensions.new(rows, columns)
  end

  def first_row
    @rows[0] || []
  end

  def first_column
    @rows.map { |row| row[0] }
  end

  def last_row
    @rows[@max_row_index] || []
  end

  def top_left
    Coordinates.new(0, 0)
  end

  def top_right
    Coordinates.new(0, @max_column_index)
  end

  def bottom_left
    Coordinates.new(@max_row_index, 0)
  end

  def bottom_right
    Coordinates.new(@max_row_index, @max_column_index)
  end

  def last_column
    @rows.map { |row| row[@max_column_index] }
  end

  def flatten
    @rows.flatten
  end

  def columns_before(column_number)
    column_number > 1 ? @rows.map { |row| row[0..column_number - 2] } : []
  end

  def columns_after(column_number)
    column_number < @max_row_index + 1 ? @rows.map { |row| row[column_number..@max_column_index] } : []
  end

  def transform(transformation_to_apply)
    transformation_to_apply.transform(self)
  end

  def traverse_with(method_of_traversal)
    method_of_traversal.traverse(self)
  end
end

class RectangularAreaWidth
  attr_reader :start_coordinates, :end_coordinates, :start_row, :end_row, :width

  def initialize(start_coordinates, end_coordinates, width)
    @start_coordinates = start_coordinates
    @end_coordinates = end_coordinates
    @start_row = @start_coordinates.row
    @end_row = @end_coordinates.row
    @width = width
  end
end

class Coordinates
  include Comparable

  attr_reader :row, :column

  def initialize(row, column)
    @row = row
    @column = column
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

class RowTraversal
  def traverse(matrix)
    matrix.flatten
  end
end

class SnailClockwiseTraversal
  def traverse(matrix)
    if matrix.area_less_than_or_equal?(1, 1)
      matrix.traverse_with(RowTraversal.new)
    else
      horizontally_reduced = matrix.transform(RemoveHorizontalBorders.new)

      # TODO: traverse DSL (from top left to top right, from top right minus 1 to bottom right, etc.)
      matrix.first_row +
        horizontally_reduced.last_column +
        matrix.last_row.reverse +
        horizontally_reduced.first_column.reverse +
        traverse(matrix.transform(RemoveBorders.new))
    end
  end
end

class RemoveBorders
  def transform(matrix)
    matrix.transform(RemoveHorizontalBorders.new)
          .transform(RemoveVerticalBorders.new)
  end
end

class RemoveHorizontalBorders
  def transform(matrix)
    rows = matrix.rows[1, matrix.rows.length - 2] || []
    Matrix.new(rows)
  end
end

class RemoveVerticalBorders
  def transform(matrix)
    rows = matrix.rows.map { |row| row[1, matrix.max_column_index - 1] }
    Matrix.new(rows)
  end
end

class RemoveColumnNumbered
  def initialize(number_of_column_to_remove)
    @number_of_column_to_remove = number_of_column_to_remove
  end

  def transform(matrix)
    rows = matrix.columns_before(@number_of_column_to_remove)
                 .zip(matrix.columns_after(@number_of_column_to_remove))
                 .map(&:flatten)
                 .map { |cells| cells.filter { |cell| !cell.nil? } }

    Matrix.new(rows)
  end
end