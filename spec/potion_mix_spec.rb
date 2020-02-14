require "potion_mix"

describe "color component mix" do
  it "mix color 0 with volume 10 and color 0 with volume 5" do
    color_component1 = ColorComponent.new(0, 10)
    color_component2 = ColorComponent.new(0, 5)

    expect(color_component1.mix(color_component2)).to eq ColorComponent.new(0, 15)
  end
  it "mix color 255 with volume 10 and color 0 with volume 5" do
    color_component1 = ColorComponent.new(255, 10)
    color_component2 = ColorComponent.new(0, 5)

    expect(color_component1.mix(color_component2)).to eq ColorComponent.new(170, 15)
  end
  it "mix color 255 with volume 7 and color 0 with volume 12" do
    color_component1 = ColorComponent.new(255, 7)
    color_component2 = ColorComponent.new(51, 12)

    expect(color_component1.mix(color_component2)).to eq ColorComponent.new(127, 19)
  end
end

describe "Potion mix" do
  it "mix two Potions" do
    potion1 = Potion.new([153, 210, 199], 32)
    potion2 = Potion.new([135, 34, 0], 17)

    mix_potion = potion1.mix(potion2)

    expect(mix_potion.color).to eq [147, 149, 130]
    expect(mix_potion.volume).to eq 49
  end
  it "mix several Potions" do
    potions = [
      Potion.new([153, 210, 199], 32),
      Potion.new([135, 34, 0], 17),
      Potion.new([18, 19, 20], 25),
      Potion.new([174, 211, 13], 4),
      Potion.new([255, 23, 148], 19),
      Potion.new([51, 102, 51], 6),
    ]
    a = potions[0].mix(potions[1])
    b = potions[0].mix(potions[2]).mix(potions[4])
    c = potions[1].mix(potions[2]).mix(potions[3]).mix(potions[5])
    d = potions[0].mix(potions[1]).mix(potions[2]).mix(potions[4]).mix(potions[5])
    e = potions[0].mix(potions[1]).mix(potions[2]).mix(potions[3]).mix(potions[4]).mix(potions[5])

    expect(a.color).to eq [147, 149, 130]
    expect(a.volume).to eq 49
    expect(b.color).to eq [135, 101, 128]
    expect(b.volume).to eq 76
    expect(c.color).to eq [74, 50, 18]
    expect(c.volume).to eq 52
    expect(d.color).to eq [130, 91, 102]
    expect(d.volume).to eq 99
    expect(e.color).to eq [132, 96, 99]
    expect(e.volume).to eq 103
  end
end
