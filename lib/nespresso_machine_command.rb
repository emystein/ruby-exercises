class CoffeeMachineCommands
  attr_reader :capsule

  def initialize
    @commands_executed = []
    @water_tank_loaded = false
  end

  def execute(command)
    @commands_executed << command
    command.execute(self)
  end

  def fill_water_tank
    @water_tank_loaded = true
  end

  def put_capsule(capsule)
    @capsule = capsule
  end

  def water_tank_loaded?
    @water_tank_loaded
  end

  def capsule_present?
    !@capsule.nil?
  end

  def check_brew_preconditions
    raise 'Water tank is empty' unless water_tank_loaded?
    raise 'Capsule is not present' unless capsule_present?
  end
end


class FillWaterTank
  def execute(coffee_machine)
    coffee_machine.fill_water_tank
  end
end


class PutCapsule
  def initialize(capsule)
    @capsule = capsule
  end

  def execute(coffee_machine)
    coffee_machine.put_capsule(@capsule)
  end
end


class BrewLungo
  def execute(coffee_machine)
    coffee_machine.check_brew_preconditions

    Lungo.new(coffee_machine.capsule)
  end
end


class BrewEspresso
  def execute(coffee_machine)
    coffee_machine.check_brew_preconditions

    Espresso.new(coffee_machine.capsule)
  end
end


class Lungo
  attr_reader :flavor

  def initialize(capsule)
    @flavor = capsule
  end

  def flavor?(a_flavor)
    @flavor == a_flavor
  end
end

class Espresso
  attr_reader :flavor

  def initialize(capsule)
    @flavor = capsule
  end

  def flavor?(a_flavor)
    @flavor == a_flavor
  end
end
