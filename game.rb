class Game
  include Bank
  attr_reader :ui

  def initialize(ui)
    @ui = ui
  end
end