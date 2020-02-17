# https://www.codewars.com/kata/525c65e51bf619685c000059
def cakes(recipe, available)
  recipe.collect { | k, v | available[k].to_i / v }.min
end