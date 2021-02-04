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
    positioner = LeftPositioner.new(self, number_of_steps)
    move(Left, positioner, number_of_steps)
  end

  def right(number_of_steps)
    positioner = RightPositioner.new(self, number_of_steps)
    move(Right, positioner, number_of_steps)
  end

  def up(number_of_steps)
    positioner = UpPositioner.new(self, number_of_steps)
    move(Up, positioner, number_of_steps)
  end

  def down(number_of_steps)
    positioner = DownPositioner.new(self, number_of_steps)
    move(Down, positioner, number_of_steps)
  end

  def move(movement_class, coordinates, number_of_steps)
    movement = movement_class.new(self, coordinates, number_of_steps)
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
    positioner = LeftPositioner.new(@turtle, number_of_steps)
    add_tract(Left, positioner, number_of_steps)
  end

  def right(number_of_steps)
    positioner = RightPositioner.new(@turtle, number_of_steps)
    add_tract(Right, positioner, number_of_steps)
  end

  def up(number_of_steps)
    positioner = UpPositioner.new(@turtle, number_of_steps)
    add_tract(Up, positioner, number_of_steps)
  end

  def down(number_of_steps)
    positioner = DownPositioner.new(@turtle, number_of_steps)
    add_tract(Down, positioner, number_of_steps)
  end

  def add_tract(klass, positioner, steps_to_walk)
    @tracts << ItineraryTract.new(klass, self, positioner, steps_to_walk)
  end

  def traverse(matrix_to_walk, turtle)
    @tracts.map { |tract| tract.prepare(turtle) }
           .flat_map { |movement| movement.on(matrix_to_walk) }
  end
end

class ItineraryTract
  attr_reader :movement_class, :steps_to_walk

  def initialize(movement_class, turtle, positioner, steps_to_walk)
    @movement_class = movement_class
    @turtle = turtle
    @positioner = positioner
    @steps_to_walk = steps_to_walk
  end

  def prepare(turtle)
    @movement_class.new(turtle, @positioner, @steps_to_walk)
  end
end

class TurtleMovement
  attr_reader :steps_to_walk

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
  def from(position)
    GridCoordinates.new(position.row, position.column - @steps_to_walk)
  end
end

class Right < TurtleMovement
  def from(position)
    GridCoordinates.new(position.row, position.column + @steps_to_walk)
  end
end

class Up < TurtleMovement
  def from(position)
    GridCoordinates.new(position.row - @steps_to_walk, position.column)
  end
end

class Down < TurtleMovement
  def from(position)
    GridCoordinates.new(position.row + @steps_to_walk, position.column)
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

  def start_position
    raise NotImplementedError, 'Implement this'
  end

  def positions_to_cover
    raise NotImplementedError, 'Implement this'
  end

  def coordinates
    raise NotImplementedError, 'Implement this'
  end
end

class HorizontalPositioner < Positioner
  def coordinates
    positions_to_cover.map { |column| GridCoordinates.new(start_coordinates.row, column) }
  end
end

class VerticalPositioner < Positioner
  def coordinates
    positions_to_cover.map { |row| GridCoordinates.new(row, start_coordinates.column) }
  end
end

class LeftPositioner < HorizontalPositioner
  def start_position
    @turtle.at_initial_position? ? start_coordinates.column : start_coordinates.column - 1
  end

  def positions_to_cover
    start_position.downto(start_coordinates.column - @steps_to_walk)
  end
end

class RightPositioner < HorizontalPositioner
  def start_position
    @turtle.at_initial_position? ? start_coordinates.column : start_coordinates.column + 1
  end

  def positions_to_cover
    (start_position..start_position + @steps_to_walk)
  end
end

class UpPositioner < VerticalPositioner
  def start_position
    @turtle.at_initial_position? ? start_coordinates.row : start_coordinates.row - 1
  end

  def positions_to_cover
    start_position.downto(start_coordinates.row - @steps_to_walk)
  end
end

class DownPositioner < VerticalPositioner
  def start_position
    @turtle.at_initial_position? ? start_coordinates.row : start_coordinates.row + 1
  end

  def positions_to_cover
    (start_position..start_coordinates.row + @steps_to_walk)
  end
end
