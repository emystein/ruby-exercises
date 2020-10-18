require 'nespresso_machine'

describe 'Empty Coffee machine' do
  it 'prepares medium roast coffee' do
    coffee_machine = CoffeeMachine.new(capsule: 'medium_roast')

    coffee = coffee_machine.prepare_coffee

    expect(coffee.flavor?('medium_roast')).to be true
  end
end
