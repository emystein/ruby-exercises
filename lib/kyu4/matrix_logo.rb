require 'rectangular_dimensions'
require 'grid_coordinates'

class Turtle
  attr_accessor :current_coordinate

  def self.start_at(matrix_to_walk, initial_position)
    Turtle.new(matrix_to_walk, initial_position)
  end

  def initialize(matrix_to_walk, initial_position)
    @matrix_to_walk = matrix_to_walk
    @initial_position = initial_position
    @current_coordinate = initial_position
    @movements = []
    @traveled_path = []
  end

  def current_row
    @current_coordinate.row
  end

  def current_column
    @current_coordinate.column
  end

  def at_start?
    @current_coordinate == @initial_position
  end

  def left(number_of_steps)
    move(LeftMovementCoordinates, number_of_steps)
  end

  def right(number_of_steps)
    move(RightMovementCoordinates, number_of_steps)
  end

  def up(number_of_steps)
    move(UpMovementCoordinates, number_of_steps)
  end

  def down(number_of_steps)
    move(DownMovementCoordinates, number_of_steps)
  end

  def move(coordinates_class, number_of_steps)
    coordinates = coordinates_class.create(self, number_of_steps)
    @traveled_path << traverse(coordinates)
  end

  def traverse(coordinates)
    cell_values = coordinates.map do |coordinate|
      step_over(coordinate)
      look_at(coordinate)
    end

    cell_values.reject(&:nil?)
  end

  def step_over(coordinate)
    @current_coordinate = coordinate
  end

  def look_at(coordinate)
    @matrix_to_walk.value_at(coordinate)
  end

  def travel(itinerary)
    @traveled_path << itinerary.traverse
  end

  def traveled_so_far
    @traveled_path.flatten
  end
end

class Itinerary
  def initialize(turtle)
    @turtle_to_move = turtle
    @tracts = []
  end

  def left(number_of_steps)
    add_tract(LeftMovementCoordinates, number_of_steps)
  end

  def right(number_of_steps)
    add_tract(RightMovementCoordinates, number_of_steps)
  end

  def up(number_of_steps)
    add_tract(UpMovementCoordinates, number_of_steps)
  end

  def down(number_of_steps)
    add_tract(DownMovementCoordinates, number_of_steps)
  end

  def add_tract(klass, steps_to_walk)
    @tracts << ItineraryTract.new(klass, self, steps_to_walk)
  end

  def traverse
    @tracts.map { |tract| tract.prepare(@turtle_to_move) }
           .flat_map{ |coordinates| @turtle_to_move.traverse(coordinates) }
  end
end

class ItineraryTract
  attr_reader :movement_class, :steps_to_walk

  def initialize(movement_class, turtle, steps_to_walk)
    @movement_class = movement_class
    @turtle_to_move = turtle
    @steps_to_walk = steps_to_walk
  end

  def prepare(turtle)
    @movement_class.create(turtle, @steps_to_walk)
  end
end

class TurtleMovementCoordinates
  include Enumerable

  def initialize(turtle_to_move, steps_to_walk, positions_interval, axis_rail)
    @turtle_to_move = turtle_to_move
    @steps_to_walk = steps_to_walk
    @positions_interval = positions_interval
    @axis_rail = axis_rail
  end

  def each
    positions.map { |position| yield @axis_rail.intersect(position) }
  end

  def positions
    @positions_interval.elements(start_position, end_position)
  end

  def start_position
    # TODO: make this logic more declarative
    start_offset = @turtle_to_move.at_start? ? 0 : 1

    start_position_with_offset(start_offset)
  end

  def end_position
    start_position_with_offset(@steps_to_walk)
  end

  def start_position_with_offset(offset)
    @axis_rail.current_position_with_offset(offset)
  end
end

class MovementCoordinates
  def self.create(turtle_to_move, steps_to_walk)
    raise NotImplementedError, 'Implement this'
  end
end

class LeftMovementCoordinates < MovementCoordinates
  def self.create(turtle_to_move, steps_to_walk)
    positions = HorizontalDescendingPositions.new(turtle_to_move)
    TurtleMovementCoordinates.new(turtle_to_move, steps_to_walk, positions.positions_interval, positions.axis_rail)
  end
end

class RightMovementCoordinates < MovementCoordinates
  def self.create(turtle_to_move, steps_to_walk)
    positions = HorizontalAscendingPositions.new(turtle_to_move)
    TurtleMovementCoordinates.new(turtle_to_move, steps_to_walk, positions.positions_interval, positions.axis_rail)
  end
end

class UpMovementCoordinates < MovementCoordinates
  def self.create(turtle_to_move, steps_to_walk)
    positions = VerticalDescendingPositions.new(turtle_to_move)
    TurtleMovementCoordinates.new(turtle_to_move, steps_to_walk, positions.positions_interval, positions.axis_rail)
  end
end

class DownMovementCoordinates < MovementCoordinates
  def self.create(turtle_to_move, steps_to_walk)
    positions = VerticalAscendingPositions.new(turtle_to_move)
    TurtleMovementCoordinates.new(turtle_to_move, steps_to_walk, positions.positions_interval, positions.axis_rail)
  end
end

class Positions
  attr_reader :positions_interval, :axis_rail
end

class HorizontalDescendingPositions < Positions
  def initialize(turtle_to_move)
    @positions_interval = DescendingInterval.new
    @axis_rail = HorizontalRail.new(turtle_to_move, NegativeOffset.new)
  end
end

class HorizontalAscendingPositions < Positions
  def initialize(turtle_to_move)
    @positions_interval = AscendingInterval.new
    @axis_rail = HorizontalRail.new(turtle_to_move, PositiveOffset.new)
  end
end

class VerticalDescendingPositions < Positions
  def initialize(turtle_to_move)
    @positions_interval = DescendingInterval.new
    @axis_rail = VerticalRail.new(turtle_to_move, NegativeOffset.new)
  end
end

class VerticalAscendingPositions < Positions
  def initialize(turtle_to_move)
    @positions_interval = AscendingInterval.new
    @axis_rail = VerticalRail.new(turtle_to_move, PositiveOffset.new)
  end
end



class AxisRail
  def initialize(turtle, offset_direction)
    @turtle_to_move = turtle
    @position_offset = offset_direction
  end

  def current_position_with_offset(offset)
    @position_offset.from(current_position_on_axis, offset)
  end

  def current_position_on_axis
    raise NotImplementedError, 'Implement this'
  end

  def intersect(position)
    raise NotImplementedError, 'Implement this'
  end
end

class HorizontalRail < AxisRail
  def current_position_on_axis
    @turtle_to_move.current_column
  end

  def intersect(column)
    GridCoordinates.new(@turtle_to_move.current_row, column)
  end
end

class VerticalRail < AxisRail
  def current_position_on_axis
    @turtle_to_move.current_row
  end

  def intersect(row)
    GridCoordinates.new(row, @turtle_to_move.current_column)
  end
end

class AscendingInterval
  def elements(start_position, end_position)
    (start_position..end_position)
  end
end

class DescendingInterval
  def elements(start_position, end_position)
    start_position.downto(end_position)
  end
end

class PositiveOffset
  def from(start, steps)
    start + steps
  end
end

class NegativeOffset
  def from(start, steps)
    start - steps
  end
end
