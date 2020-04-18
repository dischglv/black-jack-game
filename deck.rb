class Deck
  def initialiaze
    @cards = full_deck
  end

  def full_deck
    Card.all_suits.each_key do |suit|
      Card.all_ranks.each do |rank|
        cards << Card.new(suit, rank)
      end
    end
  end

  def give_cards(number = 1)
    result = []
    number.times do
      cards.shuffle!
      result << cards.pop
    end
    result
  end

  protected
  attr_accessor :cards
end