require 'money'

module MoneyExtensions
  def pesos
    Money.from_amount(self, 'ARS')
  end
end

Numeric.include MoneyExtensions
