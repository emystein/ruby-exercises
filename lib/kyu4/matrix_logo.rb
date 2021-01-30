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
    @traveled_path = []
  end

  def right(number_of_steps)
    move(LeftToRight, number_of_steps)
  end

  def down(number_of_steps)
    move(Down, number_of_steps)
  end

  def move(movement_class, number_of_steps)
    movement = movement_class.new(self, number_of_steps)
    @traveled_path << movement.over(@matrix_to_walk)
  end

  def traveled_so_far
    @traveled_path.flatten
  end

  def update_position(movement)
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

  def update_position(movement)
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

  def start_coordinates
    @turtle.current_position
  end

  def positions_to_cover
    raise NotImplementedError, 'Implement this'
  end

  def over(matrix_to_walk)
    traveled = positions_to_cover.map { |position| matrix_to_walk.value_at(position) }
                                 .reject(&:nil?)

    @turtle.update_position(self)

    traveled
  end
end

class LeftToRight < TurtleMovement
  def positions_to_cover
    (start_coordinates.column..@steps_to_walk + 1).map do |column|
      GridCoordinates.new(start_coordinates.row, column)
    end
  end

  def from_position(position)
    GridCoordinates.new(position.row, position.column + @steps_to_walk)
  end
end

class Down < TurtleMovement
  def positions_to_cover
    (start_coordinates.row + 1..start_coordinates.row + @steps_to_walk). map do |row|
      GridCoordinates.new(row, start_coordinates.column)
    end
  end

  def from_position(position)
    GridCoordinates.new(position.row + @steps_to_walk, position.column)
  end
end

