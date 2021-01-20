class SquareMatrix
  attr_reader :square_matrix

  def initialize(square_matrix)
    @square_matrix = square_matrix
    @dimensions = Dimensions.new(square_matrix.length, square_matrix.length)
  end

  def snail_sorted
    if @dimensions == Dimensions.new(0, 0)
      []
    elsif @dimensions == Dimensions.new(1, 1)
      @square_matrix[0]
    else
      first_row +
        middle_right_column +
        last_row.reverse +
        middle_first_column.reverse +
        reduced.snail_sorted
    end
  end

  def first_row
    @square_matrix[0]
  end

  def middle_right_column
    @square_matrix[1, @square_matrix.length - 2].map { |e| e[@square_matrix.length - 1] }
  end

  def last_row
    @square_matrix[@square_matrix.length - 1]
  end

  def middle_first_column
    @square_matrix[1, @square_matrix.length - 2].map { |e| e[0] }
  end

  def reduced
    SquareMatrix.new(narrow_horizontal(narrow_vertical(@square_matrix)))
  end

  def narrow_horizontal(a_matrix)
    original_length = a_matrix.length
    new_length = original_length - 1
    a_matrix[1, new_length - 1]
  end

  def narrow_vertical(a_matrix)
    original_length = a_matrix.length
    new_length = original_length - 1
    a_matrix.map { |e| e[1, new_length - 1] }
  end

  def ==(other)
    @square_matrix == other.square_matrix
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
