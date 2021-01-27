class RectangularDimensions
  include Comparable

  attr_reader :base, :height, :area

  def initialize(base, height)
    @base = base
    @height = height
    @area = @base * @height
  end

  def <=>(other)
    area <=> other.area
  end
end

