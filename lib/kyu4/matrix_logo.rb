require 'rectangular_dimensions'
require 'grid_coordinates'

class Turtle
  attr_reader :current_position

  def self.start_at(matrix_to_walk, initial_position)
    Turtle.new(matrix_to_walk, initial_position)
  end

  def initialize(matrix_to_walk, initial_position)
    @matrix_to_walk = matrix_to_walk
    @current_position = initial_position
    @movements = []
    @traversed_path = []
  end

  def right(number_of_steps)
    move(LeftToRight, number_of_steps)
  end

  def down(number_of_steps)
    move(Down, number_of_steps)
  end

  def move(movement_class, number_of_steps)
    movement = movement_class.new(self, number_of_steps)
    @traversed_path << movement.over(@matrix_to_walk)
  end

  def traveled_so_far
    @traversed_path.flatten
  end

  def increment_position(movement)
    @current_position = movement.from_position(@current_position)
  end
end

class TurtleRoutePlan
  attr_reader :current_position

  def self.start_at(initial_position)
    TurtleRoutePlan.new(initial_position)
  end

  def initialize(initial_position)
    @current_position = initial_position
    @movements = []
  end

  def right(number_of_steps)
    add_movement(LeftToRight, number_of_steps)
  end

  def down(number_of_steps)
    add_movement(Down, number_of_steps)
  end

  def walk_on(matrix_to_walk)
    @movements.flat_map { |movement| movement.over(matrix_to_walk) }
  end

  def increment_position(movement)
    @current_position = movement.from_position(@current_position)
  end

  private

  def add_movement(klass, number_of_steps)
    @movements << klass.new(self, number_of_steps)
  end
end

class TurtleMovement
  attr_reader :steps_to_walk

  def initialize(turtle_to_move, steps_to_walk)
    @turtle = turtle_to_move
    @steps_to_walk = steps_to_walk
  end

  def over(matrix_to_walk)
    raise NotImplementedError, 'Implement this'
  end
end

class LeftToRight < TurtleMovement
  def over(matrix_to_walk)
    from = @turtle.current_position

    @turtle.increment_position(self)

    (from.column..@steps_to_walk + 1).map { |column| matrix_to_walk.value_at(GridCoordinates.new(from.row, column)) }
                                     .reject(&:nil?)
  end

  def from_position(position)
    GridCoordinates.new(position.row, position.column + @steps_to_walk)
  end
end

class Down < TurtleMovement
  def over(matrix_to_walk)
    from = @turtle.current_position

    @turtle.increment_position(self)

    (from.row + 1..from.row + @steps_to_walk).map { |row| matrix_to_walk.value_at(GridCoordinates.new(row, from.column)) }
                                             .filter { |v| !v.nil? }
  end

  def from_position(position)
    GridCoordinates.new(position.row + @steps_to_walk, position.column)
  end
end

