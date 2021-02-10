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
    coordinates = coordinates_class.new(self, number_of_steps)

    @traveled_path << traverse(coordinates)
  end

  def traverse(coordinates)
    cell_values = coordinates.map do |coordinate|
      step_over(coordinate)
      content_of(coordinate)
    end

    cell_values.reject(&:nil?)
  end

  def step_over(coordinate)
    @current_coordinate = coordinate
  end

  def content_of(coordinate)
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
           .flat_map { |coordinates| @turtle_to_move.traverse(coordinates) }
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
    @movement_class.new(turtle, @steps_to_walk)
  end
end

class TurtleMovementCoordinates
  include Enumerable

  def initialize(axis_rail)
    @axis_rail = axis_rail
  end

  def each(&block)
    @axis_rail.coordinates.map(&block)
  end
end

class LeftMovementCoordinates < TurtleMovementCoordinates
  def initialize(turtle_to_move, steps_to_walk)
    super(HorizontalRail.new(turtle_to_move, DescendingInterval.new, steps_to_walk))
  end
end

class RightMovementCoordinates < TurtleMovementCoordinates
  def initialize(turtle_to_move, steps_to_walk)
    super(HorizontalRail.new(turtle_to_move, AscendingInterval.new, steps_to_walk))
  end
end

class UpMovementCoordinates < TurtleMovementCoordinates
  def initialize(turtle_to_move, steps_to_walk)
    super(VerticalRail.new(turtle_to_move, DescendingInterval.new, steps_to_walk))
  end
end

class DownMovementCoordinates < TurtleMovementCoordinates
  def initialize(turtle_to_move, steps_to_walk)
    super(VerticalRail.new(turtle_to_move, AscendingInterval.new, steps_to_walk))
  end
end

class AxisRail
  def initialize(turtle, positions_interval, limit_position)
    @turtle_to_move = turtle
    @positions_interval = positions_interval
    @limit_position = limit_position
  end

  def coordinates
    positions_in_interval(@positions_interval).map { |position| intersect(position) }
  end

  def start_position
    # TODO: make this logic more declarative
    start_offset = @turtle_to_move.at_start? ? 0 : 1

    start_position_with_offset(start_offset)
  end

  def end_position
    start_position_with_offset(@limit_position)
  end

  def positions_in_interval(positions_interval)
    positions_interval.elements(start_position, end_position)
  end

  def current_position_on_axis
    raise NotImplementedError, 'Implement this'
  end

  def intersect(position)
    raise NotImplementedError, 'Implement this'
  end

  private

  def start_position_with_offset(offset)
    current_position_with_offset(offset)
  end

  def current_position_with_offset(offset)
    @positions_interval.position_with_offset(current_position_on_axis, offset)
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
