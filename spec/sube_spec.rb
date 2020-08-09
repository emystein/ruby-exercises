require 'sube'

describe 'MoneyAccount' do
  before(:each) do
    @balance_limit = BalanceLimit.new(-50)
  end

  it 'MoneyAccount has 0 pesos of funds' do
    expect(MoneyAccount.new(@balance_limit).funds).to eq 0
  end

  describe 'Minimum credit' do
    it 'No minimum when current funds are positive' do
      money_account = MoneyAccount.new(@balance_limit)
      money_account.credit(10)
      expect(money_account.funds).to eq 10
    end
    it 'Reject credit below 50 pesos when current funds are negative' do
      money_account = MoneyAccount.new(@balance_limit)
      money_account.debit(10)
      expect { money_account.credit(20) }.to raise_error 'Minimum credit must be 50 pesos'
      expect(money_account.funds).to eq(-10)
    end
    it 'Credit more than 50 pesos when current funds are negative' do
      money_account = MoneyAccount.new(@balance_limit)
      money_account.debit(10)
      money_account.credit(60)
      expect(money_account.funds).to eq(50)
    end
  end
end

describe 'User' do
  before(:each) do
    @money_account = MoneyAccount.new(BalanceLimit.new(-50))
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

describe 'Sube' do
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
      @sube.associate_card_to_user(@card, @user)
    end

    it 'register a Trip using positive funds' do
      @user.credit(10)

      @sube.record_trip(ticket_price = 10, @card)

      expect(@user.last_trip.ticket_price).to eq ticket_price
      expect(@user.last_trip.card).to eq @card
    end

    it 'register a Trip with negative funds within -50 tolerance' do
      @user.debit(20)

      @sube.record_trip(ticket_price = 10, @card)

      expect(@user.last_trip.ticket_price).to eq ticket_price
      expect(@user.last_trip.card).to eq @card
    end

    it 'reject a Trip due to funds below -50 tolerance' do
      @user.debit(50)

      expect { @sube.record_trip(ticket_price = 10, @card) }.to raise_error 'Insufficient funds'

      expect(@user.trips).to be_empty
    end

    describe 'Discounts' do
      it 'apply 10% discount on second Trip within 1 hour after first Trip' do
        @user.credit(110)

        @sube.record_trip(ticket_price = 10, @card)
        expect(@user.money_account.funds).to eq 100

        @sube.record_trip(ticket_price = 10, @card)
        expect(@user.money_account.funds).to eq 91
      end
    end
  end
end
