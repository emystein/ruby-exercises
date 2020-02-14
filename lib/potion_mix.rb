class ColorComponent
  attr_accessor :color_code, :volume

  def initialize(color_code, volume)
    @color_code = color_code
    @volume = volume
  end

  def mix(other)
    new_volume = @volume + other.volume

    color_value = ((1 + @color_code) * @volume) - 1
    other_color_value = ((1 + other.color_code) * other.volume) - 1

    new_color_value = [255, ((color_value + other_color_value) / new_volume)].min

    ColorComponent.new(new_color_value, new_volume)
  end

  def ==(other)
    @color_code == other.color_code && @volume == other.volume
  end
end

class Potion
  attr_reader :color, :volume

  def initialize(color, volume)
    @color, @volume = color, volume
  end

  def mix(other)
    v1, v2 = @volume, other.volume
    Potion.new(@color.zip(other.color).map { |c1, c2| (c1 * v1 + c2 * v2).fdiv(v1 + v2).ceil }, v1 + v2)
  end
end
