class Game
  include Bank
  attr_reader :ui

  def initialize(ui)
    @ui = ui
    @players = []
  end

  def start
    name = ui.request('Введите имя пользователя')
    user = UserPlayer.new(name)
    dealer = ComputerPlayer.new(DEALER_NAME)
    players << user << dealer
    play_round
  end

  private
  attr_accessor :players, :cards_opened, :game_over

  def play_round
    self.cards_opened = false
    self.game_over = false
    
  end
end