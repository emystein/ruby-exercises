# https://www.codewars.com/kata/5279f6fe5ab7f447890006a7
def pick_peaks(array)
  totals = { 'pos' => [], 'peaks' => [] }

  possible_peak_positions(array)
    .map { |index| PeakPickerElement.new(array, index) }
    .filter { |element| element.peak? }
    .each.map do |element|
    totals['pos'] << element.index
    totals['peaks'] << element.value
  end

  totals
end

def possible_peak_positions(array)
  if array.size > 2
    (1..array.size - 2)
  else
    []
  end
end

class PeakPickerElement
  attr_reader :array, :index, :value

  def initialize(array, index)
    @array = array
    @index = index
    @value = @array[@index]
  end

  def peak?
    local_maxima_position_candidate? && greater_than_neighbours?
  end

  def greater_than_neighbours?
    greater_than_previous? && has_next_different? && greater_than_next_different?
  end

  def greater_than_previous?
    @value > previous
  end

  def has_next_different?
    !next_different.nil?
  end

  def greater_than_next_different?
    @value > next_different
  end

  def previous
    @array[@index - 1]
  end

  def next_different
    @array[@index + consecutive_with_same_value.size]
  end

  private

  def local_maxima_position_candidate?
    after_first? && before_penultimate?
  end

  def after_first?
    @index.positive?
  end

  def before_penultimate?
    @index < @array.size - 1
  end

  def consecutive_with_same_value
    @array[@index...@array.size - 1].take_while { |element| element == @array[@index] }
  end
end