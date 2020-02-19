# https://www.codewars.com/kata/536e9a7973130a06eb000e9f
def calculate_damage(your_type, opponent_type, attack, defense)
  own_effectiveness = EffectivenessFactory.create(your_type)
  opponent_effectiveness = EffectivenessFactory.create(opponent_type)
  50 * (attack / defense) * own_effectiveness.against(opponent_effectiveness)
end

class EffectivenessFactory
  def self.create(type)
    Object::const_get("#{type.capitalize}Effectiveness").new
  end
end

class Effectiveness
    def against(opponent)
        effectiveness = 0.5
        
        if self.class != opponent.class then
            if self > opponent then
                effectiveness = 2
            elsif self == opponent then
                effectiveness = 1
            end
        end

        effectiveness
    end
end

class FireEffectiveness < Effectiveness
    def ==(other)
        other.class == self.class || other.class == ElectricEffectiveness
    end

    def >(other)
        other.class == GrassEffectiveness
    end
end

class WaterEffectiveness < Effectiveness
    def ==(other)
        other.class == self.class
    end
    def >(other)
        other.class == FireEffectiveness
    end
end

class GrassEffectiveness < Effectiveness
    def ==(other)
        other.class == self.class || other.class == ElectricEffectiveness
    end
    def >(other)
        other.class == WaterEffectiveness
    end
end

class ElectricEffectiveness < Effectiveness
    def ==(other)
        other.class == self.class || other.class == FireEffectiveness || other.class == GrassEffectiveness
    end
    def >(other)
        other.class == WaterEffectiveness
    end
end