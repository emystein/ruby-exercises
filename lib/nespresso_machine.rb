class CoffeeMachine
  def initialize
    @water_tank_is_loaded = false
    @capsule_is_present = false
  end

  def fill_water_tank
    @water_tank_is_loaded = true
  end

  def put_capsule(capsule)
    @capsule = capsule
    @capsule_is_present = true
  end

  def water_tank_is_loaded?
    @water_tank_is_loaded
  end

  def capsule_is_present?
    @capsule_is_present
  end

  def brew_lungo
    raise 'Water tank is empty' unless water_tank_is_loaded?
    raise 'Capsule is not present' unless capsule_is_present?

    Lungo.new(@capsule)
  end

  def brew_espresso
    Espresso.new(@capsule)
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
