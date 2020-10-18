require 'nespresso_machine'

describe 'Empty Lungo machine' do
  it 'prepares dark roast Lungo' do
    coffee_machine = CoffeeMachine.new
    coffee_machine.fill_water_tank
    coffee_machine.put_capsule('dark_roast')

    cup = coffee_machine.brew_lungo

    expect(cup.flavor?('dark_roast')).to be true
  end

  it 'prepares medium roast Espresso' do
    coffee_machine = CoffeeMachine.new
    coffee_machine.fill_water_tank
    coffee_machine.put_capsule('medium_roast')

    cup = coffee_machine.brew_espresso

    expect(cup.flavor?('medium_roast')).to be true
  end

  it 'cant prepare Lungo if water tank is empty' do
    coffee_machine = CoffeeMachine.new
    coffee_machine.put_capsule('medium_roast')

    expect { coffee_machine.brew_lungo }.to raise_error('Water tank is empty')
  end

  it 'cant prepare Lungo if there is no capsule' do
    coffee_machine = CoffeeMachine.new
    coffee_machine.fill_water_tank

    expect { coffee_machine.brew_lungo }.to raise_error('Capsule is not present')
  end
end
