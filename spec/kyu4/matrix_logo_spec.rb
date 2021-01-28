require 'kyu4/snail_sort'
require 'kyu4/matrix_logo'
require 'grid_coordinates'
require 'rspec-parameterized'

describe 'TurtleRoutePlan horizontal left to right walk' do
  where(:seed, :expected) do
    [
      [[[]], []],
      [[[1, 2]], [1, 2]]
    ]
  end

  with_them do
    it 'traverse horizontal from left to right' do
      matrix = Matrix.new(seed)

      turtle = TurtleRoutePlan.start_at(GridCoordinates.new(1, 1))
      turtle.right(1)
      traversed = turtle.walk_on(matrix)

      expect(traversed).to eq(expected)
    end
  end
end

describe 'TurtleRoutePlan horizontal left to right then down' do
  where(:seed, :expected) do
    [
      [[[]], []],
      [[[1, 2]], [1, 2]],
      [[[1, 2], [3, 4]], [1, 2, 4]]
    ]
  end

  with_them do
    it 'traverse' do
      matrix = Matrix.new(seed)

      turtle = TurtleRoutePlan.start_at(GridCoordinates.new(1, 1))
      turtle.right(1)
      turtle.down(1)
      traversed = turtle.walk_on(matrix)

      expect(traversed).to eq(expected)
    end
  end
end

describe 'Turtle walk to the right' do
  where(:seed, :expected) do
    [
      [[[]], []],
      [[[1, 2]], [1, 2]]
    ]
  end

  with_them do
    it 'walk' do
      matrix = Matrix.new(seed)

      turtle = Turtle.start_at(matrix, GridCoordinates.new(1, 1))
      turtle.right(1)

      expect(turtle.traveled_so_far).to eq(expected)
    end
  end
end

describe 'Turtle walk to the right then down' do
  where(:seed, :expected) do
    [
      [[[]], []],
      [[[1, 2]], [1, 2]],
      [[[1, 2], [3, 4]], [1, 2, 4]]
    ]
  end

  with_them do
    it 'walk' do
      matrix = Matrix.new(seed)

      turtle = Turtle.start_at(matrix, GridCoordinates.new(1, 1))
      turtle.right(1)
      turtle.down(1)

      expect(turtle.traveled_so_far).to eq(expected)
    end
  end
end

