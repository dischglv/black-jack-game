class Player
  include Bank

  attr_reader :name
  attr_accessor :cards

  def initialize(name)
    @score = 100
    @name = name
    @cards = []
  end
end