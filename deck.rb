class Deck
  attr_reader :cards

  def initialize
    @cards = full_deck
  end
  
  def full_deck
    result = []
    Card.all_suits.each_key do |suit|
      Card.all_ranks.each do |rank|
        result << Card.new(suit, rank)
      end
    end
    result
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