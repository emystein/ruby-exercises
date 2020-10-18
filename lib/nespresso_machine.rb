class CoffeeMachine
  def initialize(capsule:)
    @capsule = capsule
  end

  def prepare_coffee
    Coffee.new(@capsule)
  end
end


class Coffee
  attr_reader :flavor

  def initialize(capsule)
    @flavor = capsule
  end

  def flavor?(a_flavor)
    @flavor == a_flavor
  end
end
