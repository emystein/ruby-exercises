require 'basic_math_on_string'

describe 'Basic Math on String' do
  it 'sum 1 and 2 and 3' do
    expect(calculate('1plus2plus3')).to eq '6'
  end
  it 'substract 1 and 1' do
    expect(calculate('1minus1')).to eq '0'
  end
  it 'sum 1, 2, 3 and substract 4' do
    expect(calculate('1plus2plus3minus4')).to eq '2'
  end
end
