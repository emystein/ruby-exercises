require 'color_mixing_potion'

describe 'color component mix' do
  it 'mix color 0 with volume 10 and color 0 with volume 5' do
    color_component1 = ColorComponent.new(0, 10)
    color_component2 = ColorComponent.new(0, 5)

    expect(color_component1.mix(color_component2)).to eq ColorComponent.new(0, 15)
  end
  it 'mix color 255 with volume 10 and color 0 with volume 5' do
    color_component1 = ColorComponent.new(255, 10)
    color_component2 = ColorComponent.new(0, 5)

    expect(color_component1.mix(color_component2)).to eq ColorComponent.new(170, 15)
  end
  it 'mix color 255 with volume 7 and color 0 with volume 12' do
    color_component1 = ColorComponent.new(255, 7)
    color_component2 = ColorComponent.new(51, 12)

    expect(color_component1.mix(color_component2)).to eq ColorComponent.new(127, 19)
  end
end

describe 'Potion mix' do
  it 'mix two Potions' do
    potion1 = Potion.new([153, 210, 199], 32)
    potion2 = Potion.new([135, 34, 0], 17)
    mix_potion = potion1.mix(potion2)
    expect(mix_potion.color).to eq [147, 149, 130]
  end
end
