class Bank
  attr_accessor :money
  INITIAL_PLAYER_ACCOUNT = 100
  INITIAL_GAME_ACCOUNT = 0

  def initialize(money)
    @money = money
  end

  def give_to(destination, amount)
    take(amount)
    destination.bank.put(amount)
  end

  def take(amount)
    if score >= amount
      self.score -= amount
    else
      raise ArgumentError, 'Argument is greater than score'
    end
  end

  def put(amount)
    self.score += amount
  end
end