require 'rectangular_dimensions'
require 'grid_coordinates'
require 'kyu4/matrix_traversal'
require 'kyu4/matrix_transformation'

class Matrix
  include Enumerable

  attr_reader :dimensions, :row_count, :column_count, :first_row, :first_column, :last_row, :last_column

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

  def area_smaller_or_equal?(dimensions)
    @dimensions.area <= dimensions.area
  end

  def ==(other)
    flatten == other.flatten
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

  def value_at(position)
    at_row_column(position.row, position.column)
  end

  def at_row_column(row, column)
    puts "#{row}, #{column}"
    row = @rows[row - 1]
    row ? row[column - 1] : nil
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
