require 'rectangular_dimensions'
require 'grid_coordinates'

class Turtle
  attr_accessor :current_position

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
    movement = movement_class.new(self, number_of_steps)
    @traveled_path << movement.go
  end

  def travel(itinerary)
    @traveled_path << itinerary.traverse
  end

  def traveled_so_far
    @traveled_path.flatten
  end

  def at_initial_position?
    @current_position == @initial_position
  end

  def step_over(position)
    @current_position = position
    @matrix_to_walk.value_at(position)
  end
end

class Itinerary
  def initialize(turtle)
    @turtle_to_move = turtle
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

  def traverse
    @tracts.map { |tract| tract.prepare(@turtle_to_move) }
           .flat_map(&:go)
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

class TurtleMovement
  def initialize(turtle_to_move, steps_to_walk, positions_interval, axis_rail)
    @turtle_to_move = turtle_to_move
    @linear_positions = LinearPositions.new(turtle_to_move, steps_to_walk, axis_rail, positions_interval)
    @axis_rail = axis_rail
  end

  def go
    cell_values = coordinates.map do |coordinate|
      @turtle_to_move.step_over(coordinate)
    end

    cell_values.reject(&:nil?)
  end

  def coordinates
    @linear_positions.elements.map { |position| @axis_rail.intersect(position) }
  end
end

class Left < TurtleMovement
  def initialize(turtle_to_move, steps_to_walk)
    super(turtle_to_move, steps_to_walk, DescendingInterval.new, HorizontalRail.new(turtle_to_move, NegativeOffset.new))
  end
end

class Right < TurtleMovement
  def initialize(turtle_to_move, steps_to_walk)
    super(turtle_to_move, steps_to_walk, AscendingInterval.new, HorizontalRail.new(turtle_to_move, PositiveOffset.new))
  end
end

class Up < TurtleMovement
  def initialize(turtle_to_move, steps_to_walk)
    super(turtle_to_move, steps_to_walk, DescendingInterval.new, VerticalRail.new(turtle_to_move, NegativeOffset.new))
  end
end

class Down < TurtleMovement
  def initialize(turtle_to_move, steps_to_walk)
    super(turtle_to_move, steps_to_walk, AscendingInterval.new, VerticalRail.new(turtle_to_move, PositiveOffset.new))
  end
end

class LinearPositions
  def initialize(turtle_to_move, steps_to_walk, axis_rail, positions_interval)
    @turtle_to_move = turtle_to_move
    @steps_to_walk = steps_to_walk
    @axis_rail = axis_rail
    @positions_interval = positions_interval
  end

  def elements
    @positions_interval.elements(start_position, end_position)
  end

  def start_position
    # TODO: make this logic more declarative
    start_offset = @turtle_to_move.at_initial_position? ? 0 : 1

    start_position_with_offset(start_offset)
  end

  def end_position
    start_position_with_offset(@steps_to_walk)
  end

  def start_position_with_offset(offset)
    @axis_rail.current_position_with_offset(offset)
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
