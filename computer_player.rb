class ComputerPlayer < Player
  def perform_turn
    if game.count_points(self) < 17 && deck_size < game.maximum_deck_size
      add_card
    else
      skip_turn
    end
  end
end