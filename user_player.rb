class UserPlayer < Player
  def perform_turn
    turn = game.ui.hash_choose('ход', turns)
    self.send turn
  rescue RuntimeError => e
    if e.message == 'Cannot add more cards, deck is a maximum size'
      game.ui.puts('Больше добавить карт нельзя, выберите другой ход')
      retry
    else
      raise e
    end
  end
end