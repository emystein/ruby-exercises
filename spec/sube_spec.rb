require 'sube'

describe 'MoneyAccount' do
  before(:each) do
    @user = User.new(dni = 26_427_162, name = 'Emiliano Menéndez')
  end

  it 'MoneyAccount has 0 pesos of funds' do
    expect(MoneyAccount.new(@user).funds).to eq 0
  end

  describe 'Minimum credit' do
    it 'No minimum when current funds are positive' do
      money_account = MoneyAccount.new(1)
      money_account.credit(10)
      expect(money_account.funds).to eq 10
    end
    it 'Reject credit below 50 pesos when current funds are negative' do
      money_account = MoneyAccount.new(1)
      money_account.debit(10)
      expect { money_account.credit(20) }.to raise_error 'Minimum credit must be 50 pesos'
      expect(money_account.funds).to eq(-10)
    end
    it 'Credit more than 50 pesos when current funds are negative' do
      money_account = MoneyAccount.new(1)
      money_account.debit(10)
      money_account.credit(60)
      expect(money_account.funds).to eq(50)
    end
  end
end

describe 'User' do
  it 'new User has no trips registered' do
    user = User.new(dni = 26_427_162, name = 'Emiliano Menéndez')

    expect(user.trips).to be_empty
  end

  it 'associates a MoneyAccount to a User' do
    user = User.new(dni = 26_427_162, name = 'Emiliano Menéndez')
    card = Card.new(1)
    user.add_card(card)

    expect(user.cards).to eq [card]
  end
end

describe 'Sube' do
  before(:each) do
    @sube = Sube.new
    @user = User.new(dni = 26_427_162, name = 'Emiliano Menéndez')
    @card = Card.new(1)
  end

  describe 'User registration' do
    it 'register a new User and assign a MoneyAccount' do
      @sube.register_user(@user)

      @sube.associate_card_to_user(@card, @user)

      expect(@sube.users_by_dni[26_427_162].cards).to include @card
    end
  end

  describe 'Trip record' do
    before(:each) do
      @sube.register_user(@user)
      @money_account = @sube.money_accounts_by_user[@user]
      @sube.associate_card_to_user(@card, @user)
    end

    it 'register a Trip using positive funds' do
      @money_account.credit(10)

      @sube.register_trip(ticket_price = 10, @card)

      registered_trip = @sube.users_by_dni[26_427_162].trips[0]
      expect(registered_trip.ticket_price).to eq ticket_price
      expect(registered_trip.card).to eq @card
    end

    it 'register a Trip with negative funds within -50 tolerance' do
      @money_account.debit(20)

      @sube.register_trip(ticket_price = 10, @card)

      registered_trip = @sube.users_by_dni[26_427_162].trips[0]
      expect(registered_trip.ticket_price).to eq ticket_price
      expect(registered_trip.card).to eq @card
    end

    it 'reject a Trip due to funds below -50 tolerance' do
      @money_account.debit(50)

      expect { @sube.register_trip(ticket_price = 10, @card) }.to raise_error 'Insufficient funds'

      expect(@sube.users_by_dni[26_427_162].trips).to be_empty
    end

    describe 'Discounts' do
      it 'apply 10% discount on second Trip within 1 hour after first Trip' do
        @money_account.credit(110)

        @sube.register_trip(ticket_price = 10, @card)
        expect(@money_account.funds).to eq 100

        @sube.register_trip(ticket_price = 10, @card)
        expect(@money_account.funds).to eq 91
      end
    end
  end
end
