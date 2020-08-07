#https://www.codewars.com/kata/55b080eabb080cd6f8000035
def odd_one_out(string)
  odds = {}

  string.chars.each do |c|
    if odds.key?(c)
      odds.delete(c)
    else
      odds[c] = true
    end
  end

  odds.keys
end
