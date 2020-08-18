require 'money_extensions'

# To avoid i18n when formatting pesos Money instances
Money.locale_backend = nil

class Bank
  def create_account(owner:, constraints:)
    BankAccount.create(owner, constraints)
  end

  def create_card(money_account)
    Card.create(money_account)
  end
end

class BankAccount
  attr_reader :number
  attr_reader :owner
  attr_reader :balance
  attr_reader :credit_precondition
  attr_reader :overdraft_limit

  def self.create(owner, constraints)
    BankAccount.new(BankAccountNumberGenerator.new.generate, owner, constraints)
  end

  def initialize(number, owner, constraints)
    @number = number
    @owner = owner
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

class NoConstraints < BankAccountConstraints
  def initialize
    super(PassDepositPrecondition.new, NoOverdraftLimit.new)
  end
end

class Card
  attr_reader :number
  attr_reader :bank_account

  def self.create(bank_account)
    Card.new(CreditCardNumberGenerator.new.generate, bank_account)
  end

  def initialize(number, bank_account)
    @number = number
    @bank_account = bank_account
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

# Deposit precondition expecting minimum credit if balance is negative and below a threshold.
class NegativeBalanceMinimumCredit
  def initialize(minimum_credit)
    @minimum_credit = minimum_credit
  end

  def check(amount_to_deposit, target_account)
    raise "Minimum credit must be #{@minimum_credit}" if target_account.negative_balance? && amount_to_deposit < @minimum_credit
  end
end

class PassDepositPrecondition
  def check(amount_to_deposit, target_account)
    # pass
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

class NoOverdraftLimit
  def check(amount_to_debit, account)
    # pass
  end
end