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
    @deck = Deck.new
    @bank = Bank.new
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

  def cards_opened?
    cards_opened
  end
  
  protected
  attr_accessor :players, :winners

  private

  def play_round
    loop do
      prepare_game
      ui.show_game_status(players, self)

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

      ui.show_game_status(players, self)
      ui.puts_final_report(winners, players - winners)
      players.each { |player| player.hand.discard_cards(deck) }

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
      player.hand.take_cards(deck, INITIAL_DECK_SIZE)
      player.give_money_to(self, BID_AMOUNT)
    end
  end

  def give_money_to(destination, amount)
    bank.give_to(destination, amount)
  end

  def full_decks?
    players.all? do |player|
      player.hand.deck_size == MAXIMUM_DECK_SIZE
    end
  end

  def define_winners
    max_points = 0
    players.each do |player|
      player_points = player.hand.points
      if player_points > max_points && player_points <= 21
        max_points = player_points
        self.winners = [player]
      elsif player_points == max_points
        self.winners << player
      end
    end
  end
end