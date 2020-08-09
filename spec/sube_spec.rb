require 'sube'

describe 'Card' do
  it 'Card has 0 pesos of funds' do
    expect(Card.new(1).funds).to eq 0
  end
  describe 'Minimum credit' do
    it 'No minimum when current funds are positive' do
      card = Card.new(1)
      card.credit(10)
      expect(card.funds).to eq 10
    end
    it 'Reject credit below 50 pesos when current funds are negative' do
      card = Card.new(1)
      card.debit(10)
      expect { card.credit(20) }.to raise_error 'Minimum credit must be 50 pesos'
      expect(card.funds).to eq(-10)
    end
    it 'Credit more than 50 pesos when current funds are negative' do
      card = Card.new(1)
      card.debit(10)
      card.credit(60)
      expect(card.funds).to eq(50)
    end
  end
end

describe 'User' do
  it 'new User has no trips registered' do
    user = User.new(dni = 26_427_162, name = 'Emiliano Menéndez')

    expect(user.trips).to be_empty
  end

  it 'associates a Card to a User' do
    user = User.new(dni = 26_427_162, name = 'Emiliano Menéndez')
    user.add_card(Card.new(1))

    expect(user.cards).to eq [Card.new(1)]
  end
end

describe 'Sube' do
  before(:each) do
    @sube = Sube.new
    @user = User.new(dni = 26_427_162, name = 'Emiliano Menéndez')
    @card = Card.new(1)
  end

  describe 'User registration' do
    it 'register a new User and assign a Card' do
      @sube.register_user(@user)

      @sube.associate_card_to_user(@card, @user)

      expect(@sube.users_by_dni[26_427_162].cards).to include @card
    end
  end

  describe 'Trip record' do
    before(:each) do
      @sube.register_user(@user)

      @sube.associate_card_to_user(@card, @user)
    end

    it 'register a Trip using positive funds' do
      @card.credit(10)

      @sube.register_trip(ticket_price = 10, @card)

      registered_trip = @sube.users_by_dni[26_427_162].trips[0]
      expect(registered_trip.ticket_price).to eq ticket_price
      expect(registered_trip.card).to eq @card
    end

    it 'register a Trip with negative funds within -50 tolerance' do
      @card.debit(20)

      @sube.register_trip(ticket_price = 10, @card)

      registered_trip = @sube.users_by_dni[26_427_162].trips[0]
      expect(registered_trip.ticket_price).to eq ticket_price
      expect(registered_trip.card).to eq @card
    end

    it 'reject a Trip due to funds below -50 tolerance' do
      @card.debit(50)

      expect { @sube.register_trip(ticket_price = 10, @card) }.to raise_error 'Insufficient funds'

      expect(@sube.users_by_dni[26_427_162].trips).to be_empty
    end

    describe 'Discounts' do
      it 'apply 10% discount on second Trip within 1 hour after first Trip' do
        @card.credit(110)

        @sube.register_trip(ticket_price = 10, @card)
        expect(@card.funds).to eq 100

        @sube.register_trip(ticket_price = 10, @card)
        expect(@card.funds).to eq 91
      end
    end
  end
end
