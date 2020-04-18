class Deck
  attr_reader :cards

  class << self
    def full_deck
      result = []
      Card.all_suits.each_key do |suit|
        Card.all_ranks.each do |rank|
          result << Card.new(suit, rank)
        end
      end
      result
    end
  end

  def initialize
    @cards = self.class.full_deck
  end

  def give_cards(number = 1)
    result = []
    number.times do
      cards.shuffle!
      result << cards.pop
    end
    result
  end

  def take_cards(*args)
    cards.concat(*args)
  end

  protected
  attr_writer :cards
end