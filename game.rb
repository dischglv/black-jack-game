class Game
  include Bank
  attr_reader :ui
  BID_AMOUNT = 10
  INITIAL_DECK_SIZE = 2
  DEALER_NAME = 'Dealer'

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
    loop do
      self.cards_opened = false
      self.game_over = false
      players.each do |player|
        player.cards = Card.random_deck(INITIAL_DECK_SIZE)
        player.give_to self, BID_AMOUNT
      end

      until game_over?
        players.first.perform_turn
        players.rotate!
      end

      break unless ui.ask('Хотите сыграть еще раз?')
    end
  end
end