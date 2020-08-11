require 'sube'
require 'money_extensions'
require 'time'

describe 'MoneyAccount' do
  before(:each) do
    @balance_limit = BalanceLimit.new(-50.pesos)
  end

  it 'starts with no funds' do
    expect(MoneyAccount.new(@balance_limit).funds).to eq 0
  end
end

describe 'Funds credit' do
  before(:each) do
    @balance_limit = BalanceLimit.new(-50.pesos)
  end

  it 'no minimum when current funds are positive' do
    account = MoneyAccount.new(@balance_limit)

    account.credit(10.pesos)

    expect(account.funds).to eq 10.pesos
  end

  it 'reject less than 50 pesos credit when current funds are negative' do
    account = MoneyAccount.new(@balance_limit)

    account.debit(10.pesos)

    expect { account.credit(20.pesos) }.to raise_error 'Minimum credit must be 50 pesos'
    expect(account.funds).to eq(-10.pesos)
  end

  it 'accept more than 50 pesos credit when current funds are negative' do
    account = MoneyAccount.new(@balance_limit)

    account.debit(10.pesos)
    account.credit(60.pesos)

    expect(account.funds).to eq 50.pesos
  end
end

describe 'User' do
  before(:each) do
    @money_account = MoneyAccount.new(BalanceLimit.new(-50.pesos))
  end

  it 'new User has no trips registered' do
    user = User.new(dni = 26_427_162, name = 'Emiliano Menéndez', @money_account)

    expect(user.trips).to be_empty
  end

  it 'associates a MoneyAccount to a User' do
    user = User.new(dni = 26_427_162, name = 'Emiliano Menéndez', @money_account)
    card = Card.new(1)

    user.add_card(card)

    expect(user.cards).to eq [card]
  end
end

describe 'User registration' do
  it 'register a new User and associate a Card' do
    sube = Sube.new

    card = Card.new(1)

    user = sube.register_user(dni: 26_427_162, name: 'Emiliano Menéndez')

    sube.associate_card_to_user(card, user)

    expect(user.cards).to include card
  end
end

describe 'Trip record' do
  before(:each) do
    @sube = Sube.new
    @user = @sube.register_user(dni: 26_427_162, name: 'Emiliano Menéndez')
    @card = Card.new(1)
    @sube.associate_card_to_user(@card, @user)
  end

  describe 'Accept Trip' do
    it 'use positive funds' do
      @user.credit(10.pesos)

      record_10_pesos_trip(Time.new)
    end

    it 'use negative funds within -50 tolerance' do
      @user.debit(20.pesos)

      record_10_pesos_trip(Time.new)
    end
  end

  describe 'Reject Trip' do
    it 'due to funds below -50 tolerance' do
      @user.debit(50.pesos)

      expect { @sube.record_trip(Time.new, 10.pesos, @card) }.to raise_error 'Insufficient funds'

      expect(@user.trips).to be_empty
    end
  end

  describe 'Discount on Trip' do
    it 'apply 10% discount within one hour after previous Trip' do
      @user.credit(100.pesos)

      record_10_pesos_trip_with_final_funds(Time.new, 90.pesos)
      record_10_pesos_trip_with_final_funds(Time.new, 81.pesos)
    end
    it 'do not apply 10% discount past one hour after previous Trip' do
      @user.credit(100.pesos)

      record_10_pesos_trip_with_final_funds(Time.parse('2020-08-09 13:00:00'), 90.pesos)
      record_10_pesos_trip_with_final_funds(Time.parse('2020-08-09 15:00:00'), 80.pesos)
    end
  end
end

def record_10_pesos_trip(trip_start)
  @sube.record_trip(trip_start, 10.pesos, @card)

  expect(@user.last_trip).to eq Trip.new(trip_start, 10.pesos, @card)
end

def record_10_pesos_trip_with_final_funds(trip_start, final_funds)
  @sube.record_trip(trip_start, 10.pesos, @card)

  expect(@user.funds).to eq final_funds
end
