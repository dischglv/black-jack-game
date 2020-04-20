class Player
  attr_reader :name
  attr_accessor :bank, :hand

  def initialize(name)
    @name = name
    @bank = Bank.new(100)
    @hand = Hand.new
  end

  def give_money_to(destination, amount)
    bank.give_to(destination, amount)
  end

  protected
  attr_accessor :game
end