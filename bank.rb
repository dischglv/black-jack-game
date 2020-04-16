module Bank
  attr_accessor :score

  def give_to(destination, amount)
    take(amount)
    destination.put(amount)
  end

  def take(amount)
    if score > amount
      self.score -= amount
    else
      raise ArgumentError, 'Argument is greater than score'
    end
  end

  def put(amount)
    self.score += amount
  end
end