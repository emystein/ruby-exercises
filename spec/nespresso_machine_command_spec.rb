require 'nespresso_machine_command'


describe 'Empty coffee machine' do
  it 'prepares dark roast Lungo' do
    coffee_machine = CoffeeMachineCommands.new
    fill_water_tank = FillWaterTank.new
    coffee_machine.execute(fill_water_tank)
    put_capsule = PutCapsule.new('dark_roast')
    coffee_machine.execute(put_capsule)
    brew_lungo = BrewLungo.new
    cup = coffee_machine.execute(brew_lungo)

    expect(cup.flavor?('dark_roast')).to be true
  end

  it 'prepares medium roast Espresso' do
    coffee_machine = CoffeeMachineCommands.new
    fill_water_tank = FillWaterTank.new
    coffee_machine.execute(fill_water_tank)
    put_capsule = PutCapsule.new('medium_roast')
    coffee_machine.execute(put_capsule)
    brew_espresso = BrewEspresso.new
    cup = coffee_machine.execute(brew_espresso)

    expect(cup.flavor?('medium_roast')).to be true
  end

  it 'cant prepare Lungo if water tank is empty' do
    coffee_machine = CoffeeMachineCommands.new
    put_capsule = PutCapsule.new('medium_roast')
    coffee_machine.execute(put_capsule)
    brew_lungo = BrewLungo.new

    expect { coffee_machine.execute(brew_lungo) }.to raise_error('Water tank is empty')
  end

  it 'cant prepare Lungo if there is no capsule' do
    coffee_machine = CoffeeMachineCommands.new
    fill_water_tank = FillWaterTank.new
    coffee_machine.execute(fill_water_tank)
    brew_lungo = BrewLungo.new

    expect { coffee_machine.execute(brew_lungo) }.to raise_error('Capsule is not present')
  end
end
