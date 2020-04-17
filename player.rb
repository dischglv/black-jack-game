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
end