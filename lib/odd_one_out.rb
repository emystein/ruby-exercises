#https://www.codewars.com/kata/55b080eabb080cd6f8000035
def odd_one_out(word)
    word.chars.uniq
    .map{|c| position_and_count(c, word)}
    .select{|p| p.count.odd?}
    .sort_by{|p| p.position}
    .map{|p| p.char}
end

def position_and_count(char, word)
    position = 0
    count = 0

    p = 0
    word.chars.each do |c|
        if c == char
            position = p
            count = count + 1
        end
        p = p + 1
    end

    PositionAndCount.new(char, position, count)
end

class PositionAndCount
    attr_reader :char, :position, :count

    def initialize(char, position, count)
        @char = char
        @position = position
        @count = count
    end

    def ==(other)
        self.char == other.char &&
        self.position == other.position &&
        self.count == other.count
    end
end