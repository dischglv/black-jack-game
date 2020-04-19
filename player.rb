class Player
  attr_reader :name
  attr_accessor :cards, :bank

  def initialize(name, game)
    @score = INITIAL_SCORE
    @name = name
    @cards = []
    @game = game
    @bank = Bank.new(Bank.INITIAL_PLAYER_ACCOUNT)
  end

  def deck_size
    cards.length
  end

  def take_card(number = 1)
    cards.concat(game.deck.give_cards(number))
  end

  def discard_cards
    game.deck.take_cards(cards)
    self.cards = []
  end

  def give_money_to(destination, amount)
    bank.give_to(destination, amount)
  end
  
  protected
  attr_accessor :game

  def skip_turn
  end

  def add_card
    raise 'Cannot add more cards, deck is a maximum size' if deck_size == game.maximum_deck_size
    take_card
    game.ui.puts(game.game_status)
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