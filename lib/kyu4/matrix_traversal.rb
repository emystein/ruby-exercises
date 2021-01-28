class LeftRightTopDownTraversal
  def traverse(matrix)
    matrix.flatten
  end
end

class SnailClockwiseTraversal
  def traverse(matrix)
    if matrix.area_smaller_or_equal?(RectangularDimensions.new(1, 1))
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

