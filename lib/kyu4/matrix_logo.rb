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

  def right(number_of_steps)
    move(Right, number_of_steps)
  end

  def up(number_of_steps)
    move(Up, number_of_steps)
  end

  def down(number_of_steps)
    move(Down, number_of_steps)
  end

  def left(number_of_steps)
    move(Left, number_of_steps)
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
  def initialize
    @tracts = []
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

  def left(number_of_steps)
    add_tract(Left, number_of_steps)
  end

  def add_tract(klass, steps_to_walk)
    @tracts << ItineraryTract.new(klass, steps_to_walk)
  end

  def traverse(matrix_to_walk, turtle)
    @tracts.map { |tract| tract.prepare(turtle) }
           .flat_map { |movement| movement.on(matrix_to_walk) }
  end
end

class ItineraryTract
  attr_reader :movement_class, :steps_to_walk

  def initialize(movement_class, steps_to_walk)
    @movement_class = movement_class
    @steps_to_walk = steps_to_walk
  end

  def prepare(turtle)
    @movement_class.new(turtle, @steps_to_walk)
  end
end

class TurtleMovement
  attr_reader :steps_to_walk

  def initialize(turtle_to_move, steps_to_walk)
    @turtle = turtle_to_move
    @steps_to_walk = steps_to_walk
  end

  def start_coordinates
    @turtle.current_position
  end

  def positions_to_cover
    raise NotImplementedError, 'Implement this'
  end

  def coordinates_to_cover
    raise NotImplementedError, 'Implement this'
  end

  def on(matrix_to_walk)
    traveled = coordinates_to_cover.map { |position| matrix_to_walk.value_at(position) }
                                   .reject(&:nil?)

    @turtle.update_position(self)

    traveled
  end
end

class LeftPositioner
  def initialize(turtle, steps_to_walk)
    @turtle = turtle
    @steps_to_walk = steps_to_walk
  end

  def start_coordinates
    @turtle.current_position
  end

  def start_position
    @turtle.at_initial_position? ? start_coordinates.column : start_coordinates.column - 1
  end

  def positions_to_cover
    start_position.downto(start_coordinates.column - @steps_to_walk)
  end
end

class Left < TurtleMovement
  def initialize(turtle_to_move, steps_to_walk)
    super(turtle_to_move, steps_to_walk)
    @positioner = LeftPositioner.new(turtle_to_move, steps_to_walk)
  end

  def coordinates_to_cover
    @positioner.positions_to_cover.map { |column| GridCoordinates.new(@positioner.start_coordinates.row, column) }
  end

  def from(position)
    GridCoordinates.new(position.row, position.column - @steps_to_walk)
  end
end

class RightPositioner
  def initialize(turtle, steps_to_walk)
    @turtle = turtle
    @steps_to_walk = steps_to_walk
  end

  def start_coordinates
    @turtle.current_position
  end

  def start_position
    @turtle.at_initial_position? ? start_coordinates.column : start_coordinates.column + 1
  end

  def positions_to_cover
    (start_position..start_position + @steps_to_walk)
  end
end

class Right < TurtleMovement
  def initialize(turtle, steps_to_walk)
    super(turtle, steps_to_walk)
    @positioner = RightPositioner.new(turtle, steps_to_walk)
  end

  def coordinates_to_cover
    @positioner.positions_to_cover.map { |column| GridCoordinates.new(@positioner.start_coordinates.row, column) }
  end

  def from(position)
    GridCoordinates.new(position.row, position.column + @steps_to_walk)
  end
end

class UpPositioner
  def initialize(turtle, steps_to_walk)
    @turtle = turtle
    @steps_to_walk = steps_to_walk
  end

  def start_coordinates
    @turtle.current_position
  end

  def start_position
    @turtle.at_initial_position? ? start_coordinates.row : start_coordinates.row - 1
  end

  def positions_to_cover
    start_position.downto(start_coordinates.row - @steps_to_walk)
  end
end

class Up < TurtleMovement
  def initialize(turtle, steps_to_walk)
    super(turtle, steps_to_walk)
    @positioner = UpPositioner.new(turtle, steps_to_walk)
  end

  def coordinates_to_cover
    @positioner.positions_to_cover.map { |row| GridCoordinates.new(row, @positioner.start_coordinates.column) }
  end

  def from(position)
    GridCoordinates.new(position.row - @steps_to_walk, position.column)
  end
end

class DownPositioner
  def initialize(turtle, steps_to_walk)
    @turtle = turtle
    @steps_to_walk = steps_to_walk
  end

  def start_coordinates
    @turtle.current_position
  end

  def start_position
    @turtle.at_initial_position? ? start_coordinates.row : start_coordinates.row + 1
  end

  def positions_to_cover
    (start_position..start_coordinates.row + @steps_to_walk)
  end
end

class Down < TurtleMovement
  def initialize(turtle, steps_to_walk)
    super(turtle, steps_to_walk)
    @positioner = DownPositioner.new(turtle, steps_to_walk)
  end

  def coordinates_to_cover
    @positioner.positions_to_cover.map { |row| GridCoordinates.new(row, @positioner.start_coordinates.column) }
  end

  def from(position)
    GridCoordinates.new(position.row + @steps_to_walk, position.column)
  end
end
