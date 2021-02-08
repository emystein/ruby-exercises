require 'kyu4/snail_sort'
require 'kyu4/matrix_logo'
require 'grid_coordinates'
require 'rspec-parameterized'

describe 'Move left' do
  where(:seed, :steps, :iterations, :expected) do
    [
      [[[]], 1, 1, []],
      [[[1, 2, 3]], 1, 1, [3, 2]],
      [[[1, 2, 3]], 1, 2, [3, 2, 1]]
    ]
  end

  with_them do
    before(:each) do
      @matrix = Matrix.new(seed)
      @turtle_to_move = Turtle.start_at(@matrix, GridCoordinates.new(1, 3))
    end
    it 'Turtle walk' do
      (1..iterations).each do
        @turtle_to_move.left(steps)
      end

      expect(@turtle_to_move.traveled_so_far).to eq(expected)
    end
    it 'Travel following itinerary' do
      itinerary = Itinerary.new(@turtle_to_move)

      (1..iterations).each do
        itinerary.left(steps)
      end

      @turtle_to_move.travel(itinerary)

      expect(@turtle_to_move.traveled_so_far).to eq(expected)
    end
  end
end

describe 'Move right' do
  where(:seed, :steps, :iterations, :expected) do
    [
      [[[]], 1, 1, []],
      [[[1, 2, 3]], 0, 1, [1]],
      [[[1, 2, 3]], 1, 1, [1, 2]],
      [[[1, 2, 3]], 2, 1, [1, 2, 3]],
      [[[1, 2, 3]], 3, 1, [1, 2, 3]],
      [[[1, 2, 3]], 1, 2, [1, 2, 3]]
    ]
  end

  with_them do
    before(:each) do
      @matrix = Matrix.new(seed)
      @turtle_to_move = Turtle.start_at(@matrix, GridCoordinates.new(1, 1))
    end
    it 'Turtle walk' do
      (1..iterations).each do
        @turtle_to_move.right(steps)
      end

      expect(@turtle_to_move.traveled_so_far).to eq(expected)
    end
    it 'Travel following route' do
      itinerary = Itinerary.new(@turtle_to_move)

      (1..iterations).each do
        itinerary.right(steps)
      end

      @turtle_to_move.travel(itinerary)

      expect(@turtle_to_move.traveled_so_far).to eq(expected)
    end
  end
end

describe 'Move up' do
  where(:seed, :initial_row, :steps, :iterations, :expected) do
    [
      [[[]], 2, 1, 1, []],
      [[[1, 2], [3, 4]], 2, 1, 1, [3, 1]],
      [[[1, 2, 3], [4, 5, 6], [7, 8, 9]], 2, 1, 1, [4, 1]],
      [[[1, 2, 3], [4, 5, 6], [7, 8, 9]], 3, 1, 2, [7, 4, 1]]
    ]
  end

  with_them do
    before(:each) do
      @matrix = Matrix.new(seed)
      @turtle_to_move = Turtle.start_at(@matrix, GridCoordinates.new(initial_row, 1))
    end
    it 'Turtle walk' do
      (1..iterations).each do
        @turtle_to_move.up(steps)
      end

      expect(@turtle_to_move.traveled_so_far).to eq(expected)
    end
    it 'Travel following itinerary' do
      itinerary = Itinerary.new(@turtle_to_move)

      (1..iterations).each do
        itinerary.up(steps)
      end

      @turtle_to_move.travel(itinerary)

      expect(@turtle_to_move.traveled_so_far).to eq(expected)
    end
  end
end

describe 'Move down' do
  where(:seed, :steps, :iterations, :expected) do
    [
      [[[]], 1, 1, []],
      [[[1, 2]], 1, 1, [1]],
      [[[1, 2], [3, 4]], 1, 1, [1, 3]],
      [[[1, 2, 3], [4, 5, 6], [7, 8, 9]], 1, 1, [1, 4]],
      [[[1, 2, 3], [4, 5, 6], [7, 8, 9]], 1, 2, [1, 4, 7]]
    ]
  end

  with_them do
    before(:each) do
      @matrix = Matrix.new(seed)
      @turtle_to_move = Turtle.start_at(@matrix, GridCoordinates.new(1, 1))
    end
    it 'Turtle walk' do
      (1..iterations).each do
        @turtle_to_move.down(steps)
      end

      expect(@turtle_to_move.traveled_so_far).to eq(expected)
    end
    it 'Travel following itinerary' do
      itinerary = Itinerary.new(@turtle_to_move)

      (1..iterations).each do
        itinerary.down(steps)
      end

      @turtle_to_move.travel(itinerary)

      expect(@turtle_to_move.traveled_so_far).to eq(expected)
    end
  end
end

describe 'Move clocwise starting at the top left' do
  where(:seed, :steps, :expected) do
    [
      [[[1, 2], [3, 4]], 1, [1, 2, 4, 3, 1]]
    ]
  end

  with_them do
    before(:each) do
      @matrix = Matrix.new(seed)
      @turtle_to_move = Turtle.start_at(@matrix, GridCoordinates.new(1, 1))
    end
    it 'Turtle walk' do
      @turtle_to_move.right(steps)
      @turtle_to_move.down(steps)
      @turtle_to_move.left(steps)
      @turtle_to_move.up(steps)

      expect(@turtle_to_move.traveled_so_far).to eq(expected)
    end
    it 'Travel following itinerary' do
      itinerary = Itinerary.new(@turtle_to_move)
      itinerary.right(steps)
      itinerary.down(steps)
      itinerary.left(steps)
      itinerary.up(steps)

      @turtle_to_move.travel(itinerary)

      expect(@turtle_to_move.traveled_so_far).to eq(expected)
    end
  end
end
