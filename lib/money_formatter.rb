class MoneyFormatter
  class << self
    def format_amount(amount)
      amount = amount / 100.0

      p = "$#{"%.2f" % amount.abs}"

      if amount < 0
        "(#{p})"
      else
        p
      end
    end
  end
end