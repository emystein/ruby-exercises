class GridCoordinates
  attr_reader :current_row, :current_column

  def initialize(row, column)
    @row = row
    @column = column
  end
end
