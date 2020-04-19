class Hand
  # поместить в private?
  attr_accessor :cards

  def initialize
    @cards = []
  end

  def take_cards(deck, number)
    cards.concat(deck.give_cards(number))
  end

  def discard_cards(deck)
    deck.take_cards(cards)
    self.cards = []
  end

  def deck_size
    cards.length
  end

  def points
    points = 0
    points_counter = Proc.new do |card|
      case card.rank
      when 'K', 'Q', 'J'
        points += 10
      when 'A'
        points += 1
      else
        points += card.rank.to_i
      end
    end

    if cards.any? { |card| card.rank == 'A'}
      cards.sort! do |first, second|
        first.rank == 'A' ? 1 : 0
      end
      cards[0...-1].each &points_counter
      points += points + 11 > 21 ? 1 : 11
    else
      cards.each &points_counter
    end
    points
  end
end