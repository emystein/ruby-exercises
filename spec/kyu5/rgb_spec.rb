require 'kyu5/rgb'

describe 'RGB' do
  it 'converts 0, 0, 0 to 000000' do
    expect(rgb(0, 0, 0)).to eq '000000'
  end
  it 'converts 0, 0, 1 to 000001' do
    expect(rgb(0, 0, 1)).to eq '000001'
  end
  it 'converts 0, 0, -20 to 000000' do
    expect(rgb(0, 0, -20)).to eq '000000'
  end
  it 'converts 255, 255, 255 to FFFFFF' do
    expect(rgb(255, 255, 255)).to eq 'FFFFFF'
  end
  it 'converts 255, 255, 300 to FFFFFF' do
    expect(rgb(255, 255, 300)).to eq 'FFFFFF'
  end
  it 'converts 148, 0, 211 to 9400D3' do
    expect(rgb(148, 0, 211)).to eq '9400D3'
  end
end
