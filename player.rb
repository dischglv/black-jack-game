class Player
  include Bank
  INITIAL_SCORE = 100

  attr_reader :name
  attr_accessor :cards

  def initialize(name, game)
    @score = INITIAL_SCORE
    @name = name
    @cards = []
    @game = game
  end

  def deck_size
    cards.length
  end

  protected
  attr_accessor :game

  def skip_turn
  end

  def add_card
    raise 'Cannot add more cards, deck is a maximum size' if deck_size == game.maximum_deck_size
    cards << Card.random
    game.show_game_status
  end

  def open_cards
    game.cards_open = true
  end

  def turns
    {
      skip_turn: 'Пропустить ход',
      add_card: 'Добавить карту',
      open_cards: 'Открыть карты'
    }
end