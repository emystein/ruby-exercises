# https://www.codewars.com/kata/5629db57620258aa9d000014

class StringAnalysis
  def initialize(string)
    @string = string
  end

  def count_with_min(min)
    @string.chars
            .filter{|c| c != ' '}
            .group_by{ |c| c.downcase}
            .transform_values{|v| v.size}
            .filter{|k, v| v >= min}
  end
end