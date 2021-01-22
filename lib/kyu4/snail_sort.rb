require 'forwardable'

class SquareMatrix
  include Enumerable
  extend Forwardable # provides def_delegators

  attr_reader :rows

  def_delegators :rows, :each

  def initialize(rows)
    @rows = rows
    @dimensions = Dimensions.new(@rows.length, @rows.length)
    @max_row_index = @rows.length - 1
    @first_row = @rows[0] || []
    @max_column_index = @first_row.length - 1
  end

  def snail_sorted
    if @dimensions == Dimensions.new(0, 0)
      []
    elsif @dimensions == Dimensions.new(1, 1)
      @rows[0]
    else
      first_row +
        middle_last_column +
        last_row.reverse +
        middle_first_column.reverse +
        without_borders.snail_sorted
    end
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

  def last_column
    @rows.map { |row| row[@max_column_index] }
  end

  def without_borders
    without_horizontal_borders.without_vertical_borders
  end

  def without_horizontal_borders
    SquareMatrix.new(@rows[1, @rows.length - 2] || [])
  end

  def without_vertical_borders
    rows = @rows.map { |row| row[1, @max_column_index - 1] }
    SquareMatrix.new(rows)
  end

  def middle_first_column
    without_horizontal_borders.first_column
  end

  def middle_last_column
    without_horizontal_borders.last_column
  end

  def ==(other)
    @rows == other.rows
  end
end

class Dimensions
  include Comparable

  attr_reader :rows, :columns

  def initialize(rows, columns)
    @rows = rows
    @columns = columns
  end

  def <=>(other)
    @rows <=> other.rows && @columns <=> other.columns
  end
end
