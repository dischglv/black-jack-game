class Game
  include Bank
  attr_reader :ui
  BID_AMOUNT = 10
  INITIAL_DECK_SIZE = 2
  DEALER_NAME = 'Dealer'
  MAXIMUM_DECK_SIZE = 3

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

  protected
  attr_accessor :players, :cards_opened

  private
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
        self.cards_opened = true if full_decks?
      end
      # подсчет результатов, вывод, перевод денег из банка игры

      break unless ui.ask('Хотите сыграть еще раз?')
    end
  end

  # refacorme
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
    cards_opened
  end

  def full_decks?
    players.all? do |player|
      player.deck_size == MAXIMUM_DECK_SIZE
    end
  end

  def count_points(player)
    points = 0
    cards = player.cards
    points_counter = Proc.new do |card|
      case card.rank
      when 'K', 'Q', 'J'
        points += 10
      when 'A'
        points += 1
      else
        points += card.rank.to_i
      end
    end

    if cards.any? { |card| card.rank == 'A'}
      cards.sort! do |first, second|
        first.rank == 'A' ? 1 : 0
      end
      cards[0...-1].each &points_counter
      points += points + 11 > 21 ? 1 : 11
    else
      cards.each &points_counter
    end
    points
  end
end