class ComputerPlayer < Player
  def perform_turn
    if score < 17 && deck_size < game.maximum_deck_size
      add_card
    else
      skip_turn
    end
  end
end