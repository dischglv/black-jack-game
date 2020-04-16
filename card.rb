class Card
  attr_reader :suit, :rank

  def self.random
  end

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end
end