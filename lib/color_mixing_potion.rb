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

# https://www.codewars.com/kata/5981ff1daf72e8747d000091
class Potion
    attr_reader :color_components, :volume
  
    def initialize(color, volume)
        @color_components = color.map{|c| ColorComponent.new(c, volume)}
        @volume = volume
    end
    
    def color
        @color_components.map{|c| c.color_code}.to_a
    end

    def mix(other)
        mixed_colors = @color_components.zip(other.color_components).map{|c1, c2| c1.mix(c2)}.map{|c| c.color_code}.to_a
        Potion.new(mixed_colors, @volume + other.volume)
    end
end