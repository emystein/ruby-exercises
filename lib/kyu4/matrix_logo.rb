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
    movement = movement_class.new(self, number_of_steps)
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
    @movement_class.new(turtle, @steps_to_walk)
  end
end

class TurtleMovement
  def initialize(turtle_to_move, steps_to_walk, interval, axis_rail)
    @turtle = turtle_to_move
    @steps_to_walk = steps_to_walk
    @linear_positions = LinearPositions.new(turtle_to_move, steps_to_walk, axis_rail, interval)
    @axis_rail = axis_rail
  end

  def on(matrix_to_walk)
    traveled = coordinates.map { |position| matrix_to_walk.value_at(position) }.reject(&:nil?)

    @turtle.update_position(self)

    traveled
  end

  def coordinates
    @linear_positions.elements.map { |position| @axis_rail.intersect(position) }
  end
end

class Left < TurtleMovement
  def initialize(turtle_to_move, steps_to_walk)
    super(turtle_to_move, steps_to_walk, DescendingInterval.new,
          HorizontalRail.new(turtle_to_move, DescendingOffset.new))
  end

  def from(position)
    GridCoordinates.new(position.row, position.column - @steps_to_walk)
  end
end

class Right < TurtleMovement
  def initialize(turtle_to_move, steps_to_walk)
    super(turtle_to_move, steps_to_walk, AscendingInterval.new,
          HorizontalRail.new(turtle_to_move, AscendingOffset.new))
  end

  def from(position)
    GridCoordinates.new(position.row, position.column + @steps_to_walk)
  end
end

class Up < TurtleMovement
  def initialize(turtle_to_move, steps_to_walk)
    super(turtle_to_move, steps_to_walk, DescendingInterval.new,
          VerticalRail.new(turtle_to_move, DescendingOffset.new))
  end

  def from(position)
    GridCoordinates.new(position.row - @steps_to_walk, position.column)
  end
end

class Down < TurtleMovement
  def initialize(turtle_to_move, steps_to_walk)
    super(turtle_to_move, steps_to_walk, AscendingInterval.new,
          VerticalRail.new(turtle_to_move, AscendingOffset.new))
  end

  def from(position)
    GridCoordinates.new(position.row + @steps_to_walk, position.column)
  end
end

class LinearPositions
  def initialize(turtle_to_move, steps_to_walk, axis_rail, interval)
    @turtle = turtle_to_move
    @steps_to_walk = steps_to_walk
    @axis_rail = axis_rail
    @interval = interval
  end

  def elements
    @interval.elements(start_position, end_position)
  end

  def start_position
    # TODO: make this logic more declarative
    start_offset = @turtle.at_initial_position? ? 0 : 1

    start_position_with_offset(start_offset)
  end

  def end_position
    start_position_with_offset(@steps_to_walk)
  end

  def start_position_with_offset(offset)
    @axis_rail.position_with_offset(offset)
  end
end

class AxisRail
  def initialize(turtle, offset_direction)
    @turtle = turtle
    @offset_direction = offset_direction
  end

  def position_with_offset(offset)
    @offset_direction.position_with_offset(movable_position, offset)
  end

  def movable_position
    raise NotImplementedError, 'Implement this'
  end

  def intersect(position)
    raise NotImplementedError, 'Implement this'
  end
end

class HorizontalRail < AxisRail
  def movable_position
    @turtle.current_column
  end

  def intersect(column)
    GridCoordinates.new(@turtle.current_row, column)
  end
end

class VerticalRail < AxisRail
  def movable_position
    @turtle.current_row
  end

  def intersect(row)
    GridCoordinates.new(row, @turtle.current_column)
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

class AscendingOffset
  def position_with_offset(start, steps)
    start + steps
  end
end

class DescendingOffset
  def position_with_offset(start, steps)
    start - steps
  end
end
