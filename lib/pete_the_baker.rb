# https://www.codewars.com/kata/525c65e51bf619685c000059
def cakes(recipe, available)
    recipe.keys.each do |ingredient|
        if !available.has_key?(ingredient) || available[ingredient] < recipe[ingredient]
            return 0
        end
    end

    return 1 + cakes(recipe, consume_ingredients(recipe, available))
end

def consume_ingredients(recipe, available)
    new_available = available.dup

    recipe.keys.each do |ingredient|
        new_available[ingredient] -= recipe[ingredient]
    end

    new_available
end