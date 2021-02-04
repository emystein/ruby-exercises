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
    positioner = LeftPositioner.new(turtle_to_move, steps_to_walk)
    Left.new(turtle_to_move, positioner, steps_to_walk)
  end

  def from(position)
    GridCoordinates.new(position.row, position.column - @steps_to_walk)
  end
end

class Right < TurtleMovement
  def self.create(turtle_to_move, steps_to_walk)
    positioner = RightPositioner.new(turtle_to_move, steps_to_walk)
    Right.new(turtle_to_move, positioner, steps_to_walk)
  end

  def from(position)
    GridCoordinates.new(position.row, position.column + @steps_to_walk)
  end
end

class Up < TurtleMovement
  def self.create(turtle_to_move, steps_to_walk)
    positioner = UpPositioner.new(turtle_to_move, steps_to_walk)
    Up.new(turtle_to_move, positioner, steps_to_walk)
  end

  def from(position)
    GridCoordinates.new(position.row - @steps_to_walk, position.column)
  end
end

class Down < TurtleMovement
  def self.create(turtle_to_move, steps_to_walk)
    positioner = DownPositioner.new(turtle_to_move, steps_to_walk)
    Down.new(turtle_to_move, positioner, steps_to_walk)
  end

  def from(position)
    GridCoordinates.new(position.row + @steps_to_walk, position.column)
  end
end

module AscendingInterval
  def elements(start_position, end_position)
    (start_position..end_position)
  end

  def position_with_offset(start, steps)
    start + steps
  end
end

module DescendingInterval
  def elements(start_position, end_position)
    start_position.downto(end_position)
  end

  def position_with_offset(start, steps)
    start - steps
  end
end


class Positioner
  def initialize(turtle, steps_to_walk)
    @turtle = turtle
    @steps_to_walk = steps_to_walk
  end

  def start_coordinates
    @turtle.current_position
  end

  def coordinates
    elements(start_position, end_position).map { |row| new_coordinate(row) }
  end

  def new_coordinate(position)
    raise NotImplementedError, 'Implement this'
  end

  # begin start positioner
  def start_position
    @turtle.at_initial_position? ? movable_position_at_start : offset_start
  end

  def movable_position_at_start
    raise NotImplementedError, 'Implement this'
  end

  def offset_start
    start_position_with_offset(1)
  end
  # end start positioner

  def end_position
    start_position_with_offset(@steps_to_walk)
  end

  def start_position_with_offset(offset)
    position_with_offset(movable_position_at_start, offset)
  end
end

class HorizontalPositioner < Positioner
  def movable_position_at_start
    start_coordinates.column
  end

  def new_coordinate(position)
    GridCoordinates.new(start_coordinates.row, position)
  end
end

class VerticalPositioner < Positioner
  def movable_position_at_start
    start_coordinates.row
  end

  def new_coordinate(position)
    GridCoordinates.new(position, start_coordinates.column)
  end
end

class LeftPositioner < HorizontalPositioner
  include DescendingInterval
end

class RightPositioner < HorizontalPositioner
  include AscendingInterval
end

class UpPositioner < VerticalPositioner
  include DescendingInterval
end

class DownPositioner < VerticalPositioner
  include AscendingInterval
end
