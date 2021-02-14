require 'kyu4/string_mix'
require 'rspec-parameterized'

describe 'StringAnalysis' do
  it 'count by letter with minimum occurrences' do
    analysis = StringAnalysis.new('Are they here')

    expect(analysis.count_with_min(2)).to eq({'r' => 2, 'e' => 4, 'h' => 2})
  end
end