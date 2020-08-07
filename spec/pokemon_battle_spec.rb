require 'pokemon_battle'

describe 'Pokemon Battle' do
  it 'match type agains itself' do
    expect(calculate_damage('fire', 'fire', 100, 100)).to eq 25
    expect(calculate_damage('water', 'water', 100, 100)).to eq 25
    expect(calculate_damage('grass', 'grass', 100, 100)).to eq 25
    expect(calculate_damage('electric', 'electric', 100, 100)).to eq 25
  end
  it 'match fire against water' do
    expect(calculate_damage('fire', 'water', 100, 100)).to eq 25
  end
  it 'match fire against electric' do
    expect(calculate_damage('fire', 'electric', 10, 2)).to eq 250
  end
  it 'match grass against water' do
    expect(calculate_damage('grass', 'water', 100, 100)).to eq 100
  end
  it 'match electric against fire' do
    expect(calculate_damage('electric', 'fire', 100, 100)).to eq 50
  end
  it 'match grass against electric' do
    expect(calculate_damage('grass', 'electric', 57, 19)).to eq 150
  end
  it 'match grass against water' do
    expect(calculate_damage('grass', 'water', 40, 40)).to eq 100
  end
  it 'match grass against fire' do
    expect(calculate_damage('grass', 'fire', 35, 5)).to eq 175
  end
end
