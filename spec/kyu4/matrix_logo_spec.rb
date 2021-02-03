require 'kyu4/snail_sort'
require 'kyu4/matrix_logo'
require 'grid_coordinates'
require 'rspec-parameterized'

describe 'Move left' do
  where(:seed, :steps, :expected) do
    [
      [[[]], 1, []],
      [[[1, 2]], 1, [2, 1]]
    ]
  end

  with_them do
    before(:each) do
      @matrix = Matrix.new(seed)
      @turtle = Turtle.start_at(@matrix, GridCoordinates.new(1, 2))
    end
    it 'Turtle walk' do
      @turtle.left(steps)

      expect(@turtle.traveled_so_far).to eq(expected)
    end
    it 'Travel following itinerary' do
      itinerary = Itinerary.new
      itinerary.left(steps)

      @turtle.travel(itinerary)

      expect(@turtle.traveled_so_far).to eq(expected)
    end
  end
end

describe 'Move right' do
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

describe 'Move up' do
  where(:seed, :steps, :expected) do
    [
      [[[]], 1, []],
      [[[1, 2], [3, 4]], 1, [1]],
      [[[1, 2, 3], [4, 5, 6], [7, 8, 9]], 1, [1]]
    ]
  end

  with_them do
    before(:each) do
      @matrix = Matrix.new(seed)
      @turtle = Turtle.start_at(@matrix, GridCoordinates.new(2, 1))
    end
    it 'Turtle walk' do
      @turtle.up(steps)

      expect(@turtle.traveled_so_far).to eq(expected)
    end
    it 'Travel following itinerary' do
      itinerary = Itinerary.new
      itinerary.up(steps)

      @turtle.travel(itinerary)

      expect(@turtle.traveled_so_far).to eq(expected)
    end
  end
end

describe 'Move down' do
  where(:seed, :steps, :expected) do
    [
      [[[]], 1, []],
      [[[1, 2]], 1, []],
      [[[1, 2], [3, 4]], 1, [3]],
      [[[1, 2, 3], [4, 5, 6], [7, 8, 9]], 1, [4]]
    ]
  end

  with_them do
    before(:each) do
      @matrix = Matrix.new(seed)
      @turtle = Turtle.start_at(@matrix, GridCoordinates.new(1, 1))
    end
    it 'Turtle walk' do
      @turtle.down(steps)

      expect(@turtle.traveled_so_far).to eq(expected)
    end
    it 'Travel following itinerary' do
      itinerary = Itinerary.new
      itinerary.down(steps)

      @turtle.travel(itinerary)

      expect(@turtle.traveled_so_far).to eq(expected)
    end
  end
end
