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
require 'bank'

# The Sistema Unico de Boleto Electro'nico (SUBE) system.
class Sube
  attr_reader :user_by_dni

  def initialize
    @user_by_dni = {}
    @bank = Bank.new
    @ticket_price_calculator = TicketPriceCalculator.new([TwoTripsWithinLastHourDiscount.new])
    @trips_by_card = Hash.new { |hsh, key| hsh[key] = [] }
  end

  def create_card
    bank_account = @bank.create_account(SubeBankAccountConstraints.new)
    @bank.create_card(bank_account)
  end

  def register_user(dni:, name:)
    @user_by_dni[dni] = RegisteredUser.new(dni, name)
  end

  def associate_card_to_user(card, user)
    @user_by_dni[user.dni].add_card(card)
  end

  def trips_by_card(card)
    @trips_by_card[card]
  end

  def record_trip(trip_start:, ticket_price:, card:)
    trip = Trip.new(trip_start, ticket_price)

    ticket_price = @ticket_price_calculator.apply_discounts(ticket_price, trips_by_card(card))

    card.bank_account.withdraw(ticket_price)

    trips_by_card(card).push trip
  end
end

class RegisteredUser
  attr_reader :dni
  attr_reader :name
  attr_reader :cards
  attr_reader :trips

  def initialize(dni, name)
    @dni = dni
    @name = name
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

class SubeBankAccountConstraints < BankAccountConstraints
  def initialize
    super(NegativeBalanceMinimumCredit.new(50.pesos), OverdraftLimit.new(-50.pesos))
  end
end

class Trip
  attr_reader :start_time
  attr_reader :ticket_price

  def initialize(start_time, ticket_price)
    @start_time = start_time
    @ticket_price = ticket_price
  end

  def ==(other)
    @start_time == other.start_time && @ticket_price == other.ticket_price
  end
end

class TicketPriceCalculator
  def initialize(discounts)
    @discounts = discounts
  end

  def apply_discounts(ticket_price, trips)
    @discounts.reduce(ticket_price) do |calculated_price, discount|
      discount.apply(calculated_price, trips)
    end
  end
end

# Applies 10% percent discount on the price of a trip, if it starts within the first hour of the previous trip
class TwoTripsWithinLastHourDiscount
  def apply(ticket_price, trips)
    return ticket_price if trips.empty?

    if (now - trips.last.start_time) < one_hour
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
