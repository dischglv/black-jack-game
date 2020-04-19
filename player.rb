class Player
  attr_reader :name
  attr_accessor :bank, :hand

  def initialize(name, game)
    @name = name
    @game = game
    @bank = Bank.new(100)
    @hand = Hand.new
  end

  def give_money_to(destination, amount)
    bank.give_to(destination, amount)
  end

  protected
  attr_accessor :game

  def skip_turn
  end

  def add_card
    raise 'Cannot add more cards, deck is a maximum size' if hand.deck_size == game.maximum_deck_size
    hand.take_card
    game.ui.puts_game_status
  end

  def open_cards
    game.cards_opened = true
  end

  def turns
    {
      'Пропустить ход' => :skip_turn,
      'Добавить карту' => :add_card,
      'Открыть карты' => :open_cards
    }
  end
end