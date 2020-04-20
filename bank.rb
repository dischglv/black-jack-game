class Bank
  attr_accessor :money

  def initialize(money = 0)
    @money = money
  end

  def give_to(destination, amount)
    take(amount)
    destination.bank.put(amount)
  end

  def take(amount)
    if money >= amount
      self.money -= amount
    else
      raise ArgumentError, 'Argument is greater than score'
    end
  end

  def put(amount)
    self.money += amount
  end
end