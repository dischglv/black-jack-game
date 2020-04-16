class Player
  include Bank
  INITIAL_SCORE = 100

  attr_reader :name
  attr_accessor :cards

  def initialize(name)
    @score = INITIAL_SCORE
    @name = name
    @cards = []
  end
end