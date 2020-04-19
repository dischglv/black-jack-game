class Game
  attr_accessor :cards_opened, :ui, :deck, :bank
  BID_AMOUNT = 10
  INITIAL_DECK_SIZE = 2
  DEALER_NAME = 'Дилер'
  MAXIMUM_DECK_SIZE = 3

  def initialize
    @ui = ConsoleUI.new
    @players = []
    @winners = []
    @score = 0
    @deck = Deck.new
    @bank = Bank.new(Bank.INITIAL_BANK_ACCOUNT)
  end

  def start
    name = ui.request_user_name
    user = UserPlayer.new(name, self)
    dealer = ComputerPlayer.new(DEALER_NAME, self)
    players << user << dealer
    play_round
  end

  def maximum_deck_size
    MAXIMUM_DECK_SIZE
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
      ui.show_game_status(players, money)

      until cards_opened?
        ui.inform_player_move(players.first)
        players.first.perform_turn
        players.rotate!
        self.cards_opened = true if full_decks?
      end

      define_winners

      if winners.length > 1
        winners.each { |winner| give_money_to(winner, BID_AMOUNT)}
      elsif winners.length == 1
        give_money_to(winners.first, bank.money)
      end

      ui.show_game_status(players, money)
      ui.puts_final_report(winners, players - winners)
      players.each { |player| player.discard_cards }

      break unless ui.ask_play_more
    end

  rescue ArgumentError => e
    if e.message == 'Argument is greater than score'
      ui.inform_game_over
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
      player.give_money_to(self, BID_AMOUNT)
    end
  end

  def give_money_to(destination, amount)
    bank.give_to(destination, amount)
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
end