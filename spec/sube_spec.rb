require 'sube'
require 'money_extensions'
require 'time'

describe 'MoneyAccount' do
  before(:each) do
    @overdraft_limit = OverdraftLimit.new(-50.pesos)
  end

  it 'starts with no balance' do
    expect(MoneyAccount.new(@overdraft_limit).balance).to eq 0
  end
end

describe 'MoneyAccount credit' do
  before(:each) do
    @overdraft_limit = OverdraftLimit.new(-50.pesos)
  end

  it 'no minimum when current balance are positive' do
    account = MoneyAccount.new(@overdraft_limit)

    account.credit(10.pesos)

    expect(account.balance).to eq 10.pesos
  end

  it 'reject less than 50 pesos credit when current balance are negative' do
    account = MoneyAccount.new(@overdraft_limit)

    account.debit(10.pesos)

    expect { account.credit(20.pesos) }.to raise_error 'Minimum credit must be 50 pesos'
    expect(account.balance).to eq(-10.pesos)
  end

  it 'accept more than 50 pesos credit when current balance are negative' do
    account = MoneyAccount.new(@overdraft_limit)

    account.debit(10.pesos)
    account.credit(60.pesos)

    expect(account.balance).to eq 50.pesos
  end
end

describe 'Registered User' do
  before(:each) do
    @money_account = MoneyAccount.new(OverdraftLimit.new(-50.pesos))
  end

  it 'new User has no trips registered' do
    user = RegisteredUser.new(dni = 26_427_162, name = 'Emiliano Menéndez', @money_account)

    expect(user.trips).to be_empty
  end

  it 'associates a Card to a User' do
    user = RegisteredUser.new(dni = 26_427_162, name = 'Emiliano Menéndez', @money_account)
    card = Card.new(1, @money_account)

    user.add_card(card)

    expect(user.cards).to eq [card]
  end

  it 'register a new User and associate a Card' do
    sube = Sube.new

    card = Card.new(1, @money_account)

    user = sube.register_user(dni: 26_427_162, name: 'Emiliano Menéndez')

    sube.associate_card_to_user(card, user)

    expect(user.cards).to include card
  end
end

describe 'Trip record' do
  before(:each) do
    @sube = Sube.new
    # @user = @sube.register_user(dni: 26_427_162, name: 'Emiliano Menéndez')
    @money_account = MoneyAccount.new(OverdraftLimit.new(-50.pesos))
    @card = Card.new(1, @money_account)
    # @sube.associate_card_to_user(@card, @user)
  end

  describe 'Accept Trip' do
    it 'use positive balance' do
      @card.credit(10.pesos)

      record_10_pesos_trip(Time.new)
    end

    it 'use negative balance within -50 tolerance' do
      @card.debit(20.pesos)

      record_10_pesos_trip(Time.new)
    end
  end

  describe 'Reject Trip' do
    it 'due to balance below -50 tolerance' do
      @card.debit(50.pesos)

      expect { @sube.record_trip(Time.new, 10.pesos, @card) }.to raise_error 'Insufficient funds'

      expect(@card.owner.trips).to be_empty
    end
  end

  describe 'Discount on Trip' do
    it 'apply 10% discount within one hour after previous Trip' do
      @card.credit(100.pesos)

      record_10_pesos_trip_with_final_balance(Time.new, 90.pesos)
      record_10_pesos_trip_with_final_balance(Time.new, 81.pesos)
    end
    it 'do not apply 10% discount past one hour after previous Trip' do
      @card.credit(100.pesos)

      record_10_pesos_trip_with_final_balance(Time.parse('2020-08-09 13:00:00'), 90.pesos)
      record_10_pesos_trip_with_final_balance(Time.parse('2020-08-09 15:00:00'), 80.pesos)
    end
  end
end

def record_10_pesos_trip(trip_start)
  @sube.record_trip(trip_start, 10.pesos, @card)

  expect(@card.owner.last_trip).to eq Trip.new(trip_start, 10.pesos, @card)
end

def record_10_pesos_trip_with_final_balance(trip_start, final_balance)
  @sube.record_trip(trip_start, 10.pesos, @card)

  expect(@card.money_account.balance).to eq final_balance
end
