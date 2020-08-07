require 'split_strings'

describe 'Split Strings' do
  it 'split empty string should be empty array' do
    expect(solution('')).to eq []
  end
  it 'split abc should be ab, c_' do
    expect(solution('abc')).to eq %w[ab c_]
  end
  it 'split abcd should be ab, cd' do
    expect(solution('abcd')).to eq %w[ab cd]
  end
  it 'split abcdef should be ab, cd, ef' do
    expect(solution('abcdef')).to eq %w[ab cd ef]
  end
end
