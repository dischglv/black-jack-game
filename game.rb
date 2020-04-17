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
    user = UserPlayer.new(name, self)
    dealer = ComputerPlayer.new(DEALER_NAME, self)
    players << user << dealer
    play_round
  end

  private
  attr_accessor :players, :cards_opened

  def play_round
    loop do
      self.cards_opened = false
      players.each do |player|
        player.cards = Card.random_deck(INITIAL_DECK_SIZE)
        player.give_to self, BID_AMOUNT
      end
      show_game_status

      until cards_opened?
        ui.puts("Ход игрока #{players.first.name}...")
        players.first.perform_turn
        players.rotate!
        self.cards_opened = true if maximum_deck_size?
      end
      # подсчет результатов, вывод, перевод денег из банка игры

      break unless ui.ask('Хотите сыграть еще раз?')
    end
  end

  def show_game_status
    ui.puts("----------------------------------")
    ui.puts("Банк игры: #{score}$")
    players.each { |player| ui.puts("Банк #{player.name}: #{player.score}$") }
    players.each do |player|
      if player.is_a? UserPlayer or player.is_a? ComputerPlayer && cards_opened?
        ui.print("#{player.name}:  ")
        player.cards.each { |card| ui.print("#{card} ") }
        ui.puts(",  всего очков: #{count_points(player)}")
      elsif player.is_a? ComputerPlayer && !cards_opened?
        ui.print("#{player.name}:  ")
        player.cards.each { |card| ui.print("\u1f0a0 ") }
        ui.puts("")
      end
    end
    ui.puts("----------------------------------")
  end

  def cards_opened?
  end

  def maximum_deck_size?
  end

  def count_points(player)
  end
end