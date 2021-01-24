require 'forwardable'

class Matrix
  include Enumerable
  extend Forwardable # provides def_delegators

  attr_reader :dimensions, :max_row_index, :max_column_index,
              :first_column_number, :last_column_number,
              :top_left, :top_right, :bottom_left, :bottom_right,
              :first_row, :first_column, :last_row, :last_column

  def_delegators :rows, :each

  def initialize(rows)
    @rows = rows

    @dimensions = RectangularDimensions.new(@rows.length, @rows.length)

    @first_row = @rows[0] || []
    @first_column = @rows.map { |row| row[0] }
    @max_row_index = @rows.length - 1
    @last_row = @rows[@max_row_index] || []
    @max_column_index = @first_row.length - 1
    @last_column = @rows.map { |row| row[@max_column_index] }

    @last_column_number = @first_row.length

    @top_left = Coordinates.new(0, 0)
    @top_right = Coordinates.new(0, @max_column_index)
    @bottom_left = Coordinates.new(@max_row_index, 0)
    @bottom_right = Coordinates.new(@max_row_index, @max_column_index)
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

  # TODO: model vertical slices
  def columns_before(column_number)
    column_number > 1 ? @rows.map { |row| row[0..column_number - 2] } : []
  end

  def columns_after(column_number)
    column_number < @max_row_index + 1 ? @rows.map { |row| row[column_number..@max_column_index] } : []
  end

  def transform_using(transformation)
    transformation.apply_to(self)
  end

  # TODO: generalize remove_*_borders (watch out breaking encapsulation of @rows)
  def remove_horizontal_borders
    rows = @rows[1, @rows.length - 2] || []
    Matrix.new(rows)
  end

  def remove_vertical_borders
    rows = @rows.map { |row| row[1, @max_column_index - 1] }
    Matrix.new(rows)
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
    matrix.remove_horizontal_borders
  end
end

class RemoveVerticalBorders
  def apply_to(matrix)
    matrix.remove_vertical_borders
  end
end

class RemoveColumnNumbered
  def initialize(number_of_column_to_remove)
    @number_of_column_to_remove = number_of_column_to_remove
  end

  def apply_to(matrix)
    rows = matrix.columns_before(@number_of_column_to_remove)
                 .zip(matrix.columns_after(@number_of_column_to_remove))
                 .map(&:flatten)
                 .map { |cells| cells.filter { |cell| !cell.nil? } }

    Matrix.new(rows)
  end
end