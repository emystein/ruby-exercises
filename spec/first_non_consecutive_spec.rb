require "first_non_consecutive"

describe "First non-consecutive number" do
  it "should" do
    expect(first_non_consecutive([1, 2, 3, 4, 6, 7, 8])).to eq 6
    expect(first_non_consecutive([1, 2, 3, 4, 5, 6, 7, 8])).to eq nil
    expect(first_non_consecutive([4, 6, 7, 8, 9, 11])).to eq 6
    expect(first_non_consecutive([4, 5, 6, 7, 8, 9, 11])).to eq 11
    expect(first_non_consecutive([31, 32])).to eq nil
    expect(first_non_consecutive([-3, -2, 0, 1])).to eq 0
    expect(first_non_consecutive([-5, -4, -3, -1])).to eq -1
  end
end
