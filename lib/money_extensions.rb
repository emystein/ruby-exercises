require 'money'

Money.rounding_mode = BigDecimal::ROUND_HALF_UP

module MoneyExtensions
  def pesos
    Money.from_amount(self, 'ARS')
  end
end

Numeric.include MoneyExtensions
