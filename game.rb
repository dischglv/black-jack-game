class Game
  include Bank
  attr_accessor :cards_opened, :ui, :deck
  BID_AMOUNT = 10
  INITIAL_DECK_SIZE = 2
  DEALER_NAME = 'Дилер'
  MAXIMUM_DECK_SIZE = 3

  def initialize(ui)
    @ui = ui
    @players = []
    @winners = []
    @score = 0
    @deck = Deck.new
  end

  def start
    name = ui.request('Введите имя пользователя: ')
    user = UserPlayer.new(name, self)
    dealer = ComputerPlayer.new(DEALER_NAME, self)
    players << user << dealer
    play_round
  end

  def maximum_deck_size
    MAXIMUM_DECK_SIZE
  end

  def game_status
    status = "----------------------------------\n"
    status += "Банк игры: #{score}$\n"

    players.each { |player| status += "Банк #{player.name}: #{player.score}$\n" }

    players.each do |player|
      if player.is_a?(UserPlayer) || (player.is_a?(ComputerPlayer) && cards_opened?)
        status += "#{player.name}:  "
        player.cards.each { |card| status += "#{card} " }
        status += "  всего очков: #{count_points(player)}\n"
      elsif player.is_a?(ComputerPlayer) && !cards_opened?
        status += "#{player.name}:  "
        player.cards.each { |card| status += "\uf0a0 " }
        status += "\n"
      end
    end
    status += "----------------------------------\n"
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

  protected
  attr_accessor :players, :winners

  private

  def play_round
    loop do
      prepare_game
      ui.puts(game_status)

      until cards_opened?
        ui.puts("Ход игрока #{players.first.name}...")
        players.first.perform_turn
        players.rotate!
        self.cards_opened = true if full_decks?
      end

      define_winners

      if winners.length > 1
        winners.each { |winner| self.give_to winner, 10}
      elsif winners.length == 1
        self.give_to winners.first, score
      end

      ui.puts(game_status)
      ui.puts(final_report)
      players.each { |player| player.discard_cards }

      break unless ui.ask('Хотите сыграть еще раз?')
    end

  rescue ArgumentError => e
    if e.message == 'Argument is greater than score'
      ui.puts('Игра закончена!')
    elsif
      raise e
    end
  end

  def prepare_game
    until players.first.is_a?(UserPlayer)
      players.rotate!
    end

    self.cards_opened = false
    players.each do |player|
      player.take_card(INITIAL_DECK_SIZE)
      player.give_to self, BID_AMOUNT
    end
  end

  def cards_opened?
    cards_opened
  end

  def full_decks?
    players.all? do |player|
      player.deck_size == MAXIMUM_DECK_SIZE
    end
  end

  def define_winners
    max_points = 0
    players.each do |player|
      player_points = count_points(player)
      if player_points > max_points && player_points <= 21
        max_points = player_points
        self.winners = [player]
      elsif player_points == max_points
        self.winners << player
      end
    end
  end

  def final_report
    report = ""

    if winners.length > 1
      report += "Игроки "
      winners.each { |winner| report += "#{winner.name} "}
      report += "сыграли ничью \n"
    elsif winners.length == 1
      report += "Игрок #{winners.first.name} выиграл\n"
    end

    losers = players - winners
    if losers.length > 0
      losers.each { |loser| report += "Игрок #{loser.name} проиграл\n" }
    end

    report
  end
end