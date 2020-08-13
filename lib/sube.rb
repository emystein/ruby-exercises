# Modelar el uso de la tarjeta Sube, para los siguientes casos de uso:
# + Revisar la implementación actual y hacer los cambios que crea necesario.
# + Agregar fondos a la tarjeta. Si el saldo actual es menor que cero el monto mínimo a cargar debe ser de 50 pesos.
#      Ejemplo: si tengo -20 pesos, el monto mínimo a cargar debe ser 50 pesos.
# + Registrar un nuevo viaje y descontar el saldo, teniendo en cuenta que:
#      - Se aplicará un descuento del 10% si el tiempo transcurrnumbero entre el viaje actual y el último es menor a una hora.
#      - Si el saldo resultante es menor a -50 pesos no se podrá realizar el viaje.
# + Se bonificará al usuario con un 15% de descuento sobre lo consumnumbero en el mes anterior, si el promedio diario
#      en días habiles fue de cinco viajes.
#      Emjemplo: durante el mes de Marzo todos los dias habiles un usuario hace cinco viajes de 20 pesos cada uno.
#      Asumiendo que hay 20 dias habiles se lo bonificará con 300 pesos.

require 'money_extensions'

# The Sistema Unico de Boleto Electro'nico (SUBE) system.
class Sube
  attr_reader :users_by_dni

  def initialize
    @users_by_dni = {}
    @bank = Bank.new
    @credit_precondition = NegativeBalanceMinimumCredit.new(50.pesos)
    @overdraft_limit = OverdraftLimit.new(-50.pesos)
    @ticket_price_calculator = TicketPriceCalculator.new([TwoTripsWithinLastHourDiscount.new])
  end

  def create_card
    @bank.create_card(create_money_account)
  end

  def money_account_of_card(card)
    @bank.money_account_of_card(card)
  end

  def register_user(dni:, name:)
    @users_by_dni[dni] = RegisteredUser.new(dni, name, create_money_account)
  end

  def associate_card_to_user(card, user)
    card.owner = user
    @users_by_dni[user.dni].add_card(card)
  end

  def record_trip(date_time, ticket_price, card)
    ticket_price = @ticket_price_calculator.apply_discounts(ticket_price, card.owner)

    money_account_of_card(card).debit(ticket_price)

    card.owner.add_trip(Trip.new(date_time, ticket_price, card))
  end

  private

  def create_money_account
    @bank.create_money_account(@credit_precondition, @overdraft_limit)
  end
end

# The Bank
class Bank
  def initialize
    @money_accounts_by_card = {}
  end

  def create_money_account(credit_precondition, overdraft_limit)
    MoneyAccount.create(credit_precondition, overdraft_limit)
  end

  def create_card(money_account)
    card = Card.create
    @money_accounts_by_card[card] = money_account
    card
  end

  def money_account_of_card(card)
    @money_accounts_by_card[card]
  end
end

class MoneyAccountNumberGenerator
  def generate
    rand 100_000_000_000
  end
end

class CreditCardNumberGenerator
  def generate
    Array.new(16) { Array('0'..'9').sample }.join
  end
end

# Calculates a the total price of a Ticket.
class TicketPriceCalculator
  def initialize(discounts)
    @discounts = discounts
  end

  def apply_discounts(ticket_price, user)
    @discounts.reduce(ticket_price) do |calculated_price, discount|
      discount.apply(calculated_price, user)
    end
  end
end

# Applies 10% percent discount on the price of a trip, if it starts within the first hour of the previous trip
class TwoTripsWithinLastHourDiscount
  def apply(ticket_price, user)
    return ticket_price if user.trips.empty?

    if (now - user.last_trip.start_time) < one_hour
      ticket_price * 0.9
    else
      ticket_price
    end
  end

  def now
    Time.new
  end

  def one_hour
    60 * 60
  end
end

class UnregisteredUser
  attr_reader :card
  attr_reader :trips

  def initialize(card)
    @card = card
    @trips = []
  end

  def ==(other)
    @card == other.card
  end

  def add_trip(trip)
    @trips << trip
  end

  def last_trip
    @trips.last
  end
end

# A user of SUBE
class RegisteredUser
  attr_reader :dni
  attr_reader :name
  attr_reader :cards
  attr_reader :money_account
  attr_reader :trips

  def initialize(dni, name, money_account)
    @dni = dni
    @name = name
    @money_account = money_account
    @cards = []
    @trips = []
  end

  def ==(other)
    @dni == other.dni && @name = other.name
  end

  def add_card(card)
    @cards << card
  end

  def add_trip(trip)
    @trips << trip
  end

  def last_trip
    @trips.last
  end
end

# A money account for a User in the SUBE
class MoneyAccount
  attr_reader :number
  attr_reader :balance
  attr_reader :credit_precondition
  attr_reader :overdraft_limit

  def self.create(credit_precondition, overdraft_limit)
    MoneyAccount.new(MoneyAccountNumberGenerator.new.generate, credit_precondition, overdraft_limit)
  end

  def initialize(number, credit_precondition, overdraft_limit)
    @number = number
    @credit_precondition = credit_precondition
    @overdraft_limit = overdraft_limit
    @balance = 0
  end

  def credit(amount)
    @credit_precondition.check(amount, self)

    @balance += amount
  end

  def debit(amount)
    @overdraft_limit.check_debit_from_account(amount, self)

    @balance -= amount
  end

  def negative_balance?
    @balance.negative?
  end
end

class NegativeBalanceMinimumCredit
  attr_reader :minimum_credit

  def initialize(minimum_credit)
    @minimum_credit = minimum_credit
  end

  def ==(other)
    @minimum_credit == other.minimum_credit
  end

  def check(amount_to_deposit, target_account)
    raise 'Minimum credit must be 50 pesos' if target_account.negative_balance? && amount_to_deposit < @minimum_credit
  end
end

class OverdraftLimit
  attr_reader :limit

  def initialize(limit)
    @limit = limit
  end

  def ==(other)
    @limit == other.limit
  end

  def check_debit_from_account(amount_to_debit, account)
    raise 'Insufficient funds' if (account.balance - amount_to_debit) < @limit
  end
end

# A plastic card used for pay trips.
class Card
  attr_reader :number
  attr_accessor :owner

  def self.create
    Card.new(CreditCardNumberGenerator.new.generate)
  end

  def initialize(number)
    @number = number
    @owner = UnregisteredUser.new(self)
  end

  def ==(other)
    @number == other.number
  end

  def add_trip(trip)
    @owner.add_trip(trip)
  end

  def last_trip
    @owner.last_trip
  end
end

# Registers a Trip
class Trip
  attr_reader :start_time
  attr_reader :ticket_price
  attr_reader :card

  def initialize(start_time, ticket_price, card)
    @start_time = start_time
    @ticket_price = ticket_price
    @card = card
  end

  def ==(other)
    @start_time == other.start_time && @ticket_price == other.ticket_price && @card == other.card
  end
end
