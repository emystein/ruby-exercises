require 'kyu4/snail_sort'
require 'kyu4/matrix_logo'
require 'grid_coordinates'
require 'rspec-parameterized'

describe 'Move horizontal left to right walk' do
  where(:seed, :steps_to_walk, :expected) do
    [
      [[[]], 1, []],
      [[[1, 2, 3]], 0, [1]],
      [[[1, 2, 3]], 1, [1, 2]],
      [[[1, 2, 3]], 2, [1, 2, 3]],
      [[[1, 2, 3]], 3, [1, 2, 3]]
    ]
  end

  with_them do
    before(:each) do
      @matrix = Matrix.new(seed)
      @turtle = Turtle.start_at(@matrix, GridCoordinates.new(1, 1))
    end
    it 'Turtle walk' do
      @turtle.right(steps_to_walk)

      expect(@turtle.traveled_so_far).to eq(expected)
    end
    it 'Travel following route' do
      itinerary = Itinerary.new
      itinerary.right(steps_to_walk)

      @turtle.travel(itinerary)

      expect(@turtle.traveled_so_far).to eq(expected)
    end
  end
end

describe 'Move right then down' do
  where(:seed, :steps_to_the_right, :steps_down,:expected) do
    [
      [[[]], 1, 1, []],
      [[[1, 2]], 1, 1, [1, 2]],
      [[[1, 2], [3, 4]], 1, 1, [1, 2, 4]]
    ]
  end

  with_them do
    before(:each) do
      @matrix = Matrix.new(seed)
      @turtle = Turtle.start_at(@matrix, GridCoordinates.new(1, 1))
    end
    it 'Turtle walk' do
      @turtle.right(steps_to_the_right)
      @turtle.down(steps_down)

      expect(@turtle.traveled_so_far).to eq(expected)
    end
    it 'Travel following route' do
      itinerary = Itinerary.new
      itinerary.right(steps_to_the_right)
      itinerary.down(steps_down)

      @turtle.travel(itinerary)

      expect(@turtle.traveled_so_far).to eq(expected)
    end
  end
end
