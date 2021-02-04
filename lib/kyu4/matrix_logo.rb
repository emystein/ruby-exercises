require 'rectangular_dimensions'
require 'grid_coordinates'

class Turtle
  attr_reader :current_position

  def self.start_at(matrix_to_walk, initial_position)
    Turtle.new(matrix_to_walk, initial_position)
  end

  def initialize(matrix_to_walk, initial_position)
    @matrix_to_walk = matrix_to_walk
    @initial_position = initial_position
    @current_position = initial_position
    @movements = []
    @traveled_path = []
  end

  def current_row
    @current_position.row
  end

  def current_column
    @current_position.column
  end

  def left(number_of_steps)
    move(Left, number_of_steps)
  end

  def right(number_of_steps)
    move(Right, number_of_steps)
  end

  def up(number_of_steps)
    move(Up, number_of_steps)
  end

  def down(number_of_steps)
    move(Down, number_of_steps)
  end

  def move(movement_class, number_of_steps)
    movement = movement_class.create(self, number_of_steps)
    @traveled_path << movement.on(@matrix_to_walk)
  end

  def travel(itinerary)
    @traveled_path << itinerary.traverse(@matrix_to_walk, self)
  end

  def traveled_so_far
    @traveled_path.flatten
  end

  def update_position(movement)
    @current_position = movement.from(@current_position)
  end

  def at_initial_position?
    @current_position == @initial_position
  end
end

class Itinerary
  def initialize(turtle)
    @turtle = turtle
    @tracts = []
  end

  def left(number_of_steps)
    add_tract(Left, number_of_steps)
  end

  def right(number_of_steps)
    add_tract(Right, number_of_steps)
  end

  def up(number_of_steps)
    add_tract(Up, number_of_steps)
  end

  def down(number_of_steps)
    add_tract(Down, number_of_steps)
  end

  def add_tract(klass, steps_to_walk)
    @tracts << ItineraryTract.new(klass, self, steps_to_walk)
  end

  def traverse(matrix_to_walk, turtle)
    @tracts.map { |tract| tract.prepare(turtle) }
           .flat_map { |movement| movement.on(matrix_to_walk) }
  end
end

class ItineraryTract
  attr_reader :movement_class, :steps_to_walk

  def initialize(movement_class, turtle, steps_to_walk)
    @movement_class = movement_class
    @turtle = turtle
    @steps_to_walk = steps_to_walk
  end

  def prepare(turtle)
    @movement_class.create(turtle, @steps_to_walk)
  end
end

class TurtleMovement
  def initialize(turtle_to_move, positioner, steps_to_walk)
    @turtle = turtle_to_move
    @positioner = positioner
    @steps_to_walk = steps_to_walk
  end

  def on(matrix_to_walk)
    traveled = @positioner.coordinates.map { |position| matrix_to_walk.value_at(position) }
                          .reject(&:nil?)

    @turtle.update_position(self)

    traveled
  end
end

class Left < TurtleMovement
  def self.create(turtle_to_move, steps_to_walk)
    positioner = HorizontalPositioner.new(turtle_to_move, steps_to_walk, DescendingInterval.new)
    Left.new(turtle_to_move, positioner, steps_to_walk)
  end

  def from(position)
    GridCoordinates.new(position.row, position.column - @steps_to_walk)
  end
end

class Right < TurtleMovement
  def self.create(turtle_to_move, steps_to_walk)
    positioner = HorizontalPositioner.new(turtle_to_move, steps_to_walk, AscendingInterval.new)
    Right.new(turtle_to_move, positioner, steps_to_walk)
  end

  def from(position)
    GridCoordinates.new(position.row, position.column + @steps_to_walk)
  end
end

class Up < TurtleMovement
  def self.create(turtle_to_move, steps_to_walk)
    positioner = VerticalPositioner.new(turtle_to_move, steps_to_walk, DescendingInterval.new)
    Up.new(turtle_to_move, positioner, steps_to_walk)
  end

  def from(position)
    GridCoordinates.new(position.row - @steps_to_walk, position.column)
  end
end

class Down < TurtleMovement
  def self.create(turtle_to_move, steps_to_walk)
    positioner = VerticalPositioner.new(turtle_to_move, steps_to_walk, AscendingInterval.new)
    Down.new(turtle_to_move, positioner, steps_to_walk)
  end

  def from(position)
    GridCoordinates.new(position.row + @steps_to_walk, position.column)
  end
end

class AscendingInterval
  def elements(start_position, end_position)
    (start_position..end_position)
  end

  def position_with_offset(start, steps)
    start + steps
  end
end

class DescendingInterval
  def elements(start_position, end_position)
    start_position.downto(end_position)
  end

  def position_with_offset(start, steps)
    start - steps
  end
end

class MovablePosition
  def initialize(start, interval)
    @start = start
    @interval = interval
  end

  def with_offset(offset)
    @interval.position_with_offset(@start, offset)
  end

  def -(other)
    @start - other
  end
end

class Positioner
  def initialize(turtle, steps_to_walk, interval)
    @turtle = turtle
    @steps_to_walk = steps_to_walk
    @interval = interval
  end

  def current_row
    MovablePosition.new(@turtle.current_row, @interval)
  end

  def current_column
    MovablePosition.new(@turtle.current_column, @interval)
  end

  def coordinates
    @interval.elements(start_position, end_position).map { |row| new_coordinate(row) }
  end

  def start_position
    offset = @turtle.at_initial_position? ? 0 : 1
    start_position_with_offset(offset)
  end

  def end_position
    start_position_with_offset(@steps_to_walk)
  end

  def start_position_with_offset(offset)
    movable_position_at_start.with_offset(offset)
  end

  def movable_position_at_start
    raise NotImplementedError, 'Implement this'
  end

  def new_coordinate(position)
    raise NotImplementedError, 'Implement this'
  end
end

class HorizontalPositioner < Positioner
  def movable_position_at_start
    current_column
  end

  def new_coordinate(column)
    GridCoordinates.new(current_row, column)
  end
end

class VerticalPositioner < Positioner
  def movable_position_at_start
    current_row
  end

  def new_coordinate(row)
    GridCoordinates.new(row, current_column)
  end
end

