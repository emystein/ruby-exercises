require "odd_one_out"

describe "odd one out" do
  it "leaves no out in empty string" do
    expect(odd_one_out("")).to eq []
  end
  it "leaves out odd characters in non-empty string" do
    expect(odd_one_out("Hello World")).to eq ["H", "e", " ", "W", "r", "l", "d"]
    expect(odd_one_out("Codewars")).to eq ["C", "o", "d", "e", "w", "a", "r", "s"]
    expect(odd_one_out("woowee")).to eq []
    expect(odd_one_out("wwoooowweeee")).to eq []
    expect(odd_one_out("racecar")).to eq ["e"]
    expect(odd_one_out("Mamma")).to eq ["M"]
    expect(odd_one_out("Mama")).to eq ["M", "m"]
  end
end
