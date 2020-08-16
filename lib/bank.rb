require 'money_extensions'

# To avoid i18n when formatting pesos Money instances
Money.locale_backend = nil

class Bank
  attr_reader :account_by_card

  def initialize
    @account_by_card = {}
  end

  def create_account(constraints)
    BankAccount.create(constraints)
  end

  def create_card(money_account)
    card = Card.create
    @account_by_card[card] = money_account
    card
  end
end

class BankAccount
  attr_reader :number
  attr_reader :balance
  attr_reader :credit_precondition
  attr_reader :overdraft_limit

  def self.create(constraints)
    BankAccount.new(BankAccountNumberGenerator.new.generate, constraints)
  end

  def initialize(number, constraints)
    @number = number
    @credit_precondition = constraints.credit_precondition
    @overdraft_limit = constraints.overdraft_limit
    @balance = 0
  end

  def deposit(amount)
    @credit_precondition.check(amount, self)

    @balance += amount
  end

  def withdraw(amount)
    @overdraft_limit.check(amount, self)

    @balance -= amount
  end

  def negative_balance?
    @balance.negative?
  end
end

class BankAccountNumberGenerator
  def generate
    rand 100_000_000_000
  end
end

class BankAccountConstraints
  attr_reader :credit_precondition
  attr_reader :overdraft_limit

  def initialize(credit_precondition, overdraft_limit)
    @credit_precondition = credit_precondition
    @overdraft_limit = overdraft_limit
  end
end

class Card
  attr_reader :number

  def self.create
    Card.new(CreditCardNumberGenerator.new.generate)
  end

  def initialize(number)
    @number = number
  end

  def ==(other)
    @number == other.number
  end
end

class CreditCardNumberGenerator
  def generate
    Array.new(16) { Array('0'..'9').sample }.join
  end
end

class NegativeBalanceMinimumCredit
  def initialize(minimum_credit)
    @minimum_credit = minimum_credit
  end

  def check(amount_to_deposit, target_account)
    raise "Minimum credit must be #{@minimum_credit}" if target_account.negative_balance? && amount_to_deposit < @minimum_credit
  end
end

class OverdraftLimit
  def initialize(limit)
    @limit = limit
  end

  def check(amount_to_debit, account)
    raise 'Insufficient funds' if (account.balance - amount_to_debit) < @limit
  end
end
