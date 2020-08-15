require 'sube'
require 'money_extensions'
require 'time'

describe 'BankAccount' do
  before(:each) do
    @credit_precondition = NegativeBalanceMinimumCredit.new(50.pesos)
    @overdraft_limit = OverdraftLimit.new(-50.pesos)
  end

  it 'starts with no balance' do
    expect(BankAccount.new(1, @credit_precondition, @overdraft_limit).balance).to eq 0
  end
end

describe 'BankAccount credit' do
  before(:each) do
    @credit_precondition = NegativeBalanceMinimumCredit.new(50.pesos)
    @overdraft_limit = OverdraftLimit.new(-50.pesos)
  end

  it 'no minimum when current balance are positive' do
    account = BankAccount.new(1, @credit_precondition, @overdraft_limit)

    account.deposit(10.pesos)

    expect(account.balance).to eq 10.pesos
  end

  it 'reject less than 50 pesos credit when current balance are negative' do
    account = BankAccount.new(1, @credit_precondition, @overdraft_limit)

    account.withdraw(10.pesos)

    expect { account.deposit(20.pesos) }.to raise_error 'Minimum credit must be 50 pesos'
    expect(account.balance).to eq(-10.pesos)
  end

  it 'accept more than 50 pesos credit when current balance are negative' do
    account = BankAccount.new(1, @credit_precondition, @overdraft_limit)

    account.withdraw(10.pesos)
    account.deposit(60.pesos)

    expect(account.balance).to eq 50.pesos
  end
end

describe 'Registered User' do
  before(:each) do
    @bank = Bank.new
    @user = RegisteredUser.new(dni = 26_427_162, name = 'Emiliano Menéndez')
  end

  it 'add a Card' do
    card = @bank.create_card(@money_account)

    @user.add_card(card)

    expect(@user.cards).to eq [card]
  end
end

describe 'Sube' do
  it 'register a new User and associate a Card' do
    sube = Sube.new

    card = sube.create_card

    user = sube.register_user(dni: 26_427_162, name: 'Emiliano Menéndez')

    sube.associate_card_to_user(card, user)

    expect(user.cards).to include card
  end
end

describe 'Trip record' do
  before(:each) do
    @sube = Sube.new
    @money_account = BankAccount.new(1, NegativeBalanceMinimumCredit.new(50.pesos), OverdraftLimit.new(-50.pesos))
    @card = @sube.create_card
  end

  describe 'Accept Trip' do
    it 'use positive balance' do
      @sube.bank_account_by_card(@card).deposit(10.pesos)

      record_10_pesos_trip(Time.new)
    end

    it 'use negative balance within -50 tolerance' do
      @sube.bank_account_by_card(@card).withdraw(20.pesos)

      record_10_pesos_trip(Time.new)
    end
  end

  describe 'Reject Trip' do
    it 'due to balance below -50 tolerance' do
      @sube.bank_account_by_card(@card).withdraw(50.pesos)

      expect { @sube.record_trip(Trip.new(Time.new, 10.pesos, @card)) }.to raise_error 'Insufficient funds'

      expect(@sube.trips_by_card(@card)).to be_empty
    end
  end

  describe 'Discount on Ticket Price' do
    it 'apply 10% discount within one hour after previous Trip' do
      @sube.bank_account_by_card(@card).deposit(100.pesos)

      record_10_pesos_trip_with_final_balance(Time.new, 90.pesos)
      record_10_pesos_trip_with_final_balance(Time.new, 81.pesos)
    end

    it 'do not apply 10% discount past one hour after previous Trip' do
      @sube.bank_account_by_card(@card).deposit(100.pesos)

      record_10_pesos_trip_with_final_balance(Time.parse('2020-08-09 13:00:00'), 90.pesos)
      record_10_pesos_trip_with_final_balance(Time.parse('2020-08-09 15:00:00'), 80.pesos)
    end
  end
end

def record_10_pesos_trip(trip_start)
  trip = Trip.new(trip_start, 10.pesos, @card)

  @sube.record_trip(trip)

  expect(@sube.trips_by_card(@card).last).to eq trip
end

def record_10_pesos_trip_with_final_balance(trip_start, final_balance)
  trip = Trip.new(trip_start, 10.pesos, @card)

  @sube.record_trip(trip)

  expect(@sube.bank_account_by_card(@card).balance).to eq final_balance
end
