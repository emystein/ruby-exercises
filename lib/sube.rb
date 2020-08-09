# Modelar el uso de la tarjeta Sube, para los siguientes casos de uso:
# + Revisar la implementación actual y hacer los cambios que crea necesario.
# + Agregar fondos a la tarjeta. Si el saldo actual es menor que cero el monto mínimo a cargar debe ser de 50 pesos.
#      Ejemplo: si tengo -20 pesos, el monto mínimo a cargar debe ser 50 pesos.
# + Registrar un nuevo viaje y descontar el saldo, teniendo en cuenta que:
#      - Se aplicará un descuento del 10% si el tiempo transcurrido entre el viaje actual y el último es menor a una hora.
#      - Si el saldo resultante es menor a -50 pesos no se podrá realizar el viaje.
# + Se bonificará al usuario con un 15% de descuento sobre lo consumido en el mes anterior, si el promedio diario
#      en días habiles fue de cinco viajes.
#      Emjemplo: durante el mes de Marzo todos los dias habiles un usuario hace cinco viajes de 20 pesos cada uno.
#      Asumiendo que hay 20 dias habiles se lo bonificará con 300 pesos.
require 'date'

# The Sistema Unico de Boleto Electro'nico (SUBE) system
class Sube
  attr_reader :users_by_dni

  def initialize
    @users_by_dni = {}
    @card_owner = {}
  end

  def register_user(user)
    @users_by_dni[user.dni] = user
  end

  def associate_card_to_user(card, user)
    @users_by_dni[user.dni].add_card(card)
    @card_owner[card] = user
  end

  def register_trip(ticket_price, card)
    check_funds_are_within_tolerance(ticket_price, card)

    ticket_price = apply_discounts(ticket_price, card)

    user = @card_owner[card]

    user.add_trip(Trip.new(ticket_price, card))
  end

  def check_funds_are_within_tolerance(ticket_price, card)
    raise 'Insufficient funds' if (card.funds - ticket_price) < -50
  end

  def apply_discounts(ticket_price, card)
    user = @card_owner[card]

    return ticket_price if user.trips.empty?

    if (now - user.trips.last.start_time) < one_hour
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

# A user of SUBE
class User
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
    card = @cards.find { |c| trip.card == c }

    card.debit(trip.ticket_price)

    @trips << trip
  end
end

# A card used for pay trips.
class Card
  attr_reader :id
  attr_reader :funds

  def initialize(id)
    @id = id
    @funds = 0
  end

  def ==(other)
    @id == other.id
  end

  def credit(amount)
    raise 'Minimum credit must be 50 pesos' if @funds.negative? && amount < 50

    @funds += amount
  end

  def debit(amount)
    @funds -= amount
  end
end

# Registers a Trip
class Trip
  attr_reader :ticket_price
  attr_reader :card
  attr_reader :start_time

  def initialize(ticket_price, card)
    @ticket_price = ticket_price
    @card = card
    @start_time = Time.new
  end

  def ==(other)
    @ticket_price == other.ticket_price && @card == other.card && @start_time == other.start_time
  end
end
