class Card
  attr_reader :suit, :rank

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
    validate!
  end

  def to_s
    rank + self.class.all_suits[suit]
  end

  class << self
    def all_suits
      { 
        Spades: "\u2660",
        Hearts: "\u2665",
        Diamonds: "\u2666",
        Clubs: "\u2663"
      }
    end

    def all_ranks
      ['A', 'K', 'Q', 'J', '10', '9', '8', '7', '6', '5', '4', '3', '2']
    end
  end

  private
  def validate!
    unless all_suits.keys.include? suit
      raise ArgumentError, "#{suit} must be one of the all_suits suit"
    end
    unless all_ranks.include? rank
      raise ArgumentError, "#{rank} must be one of the all_ranks rank"
    end
  end
end