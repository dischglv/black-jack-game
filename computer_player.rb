class ComputerPlayer < Player
  def choose_move
    if hand.points < 17 && hand.deck_size < 3
      :add_card
    else
      :skip_turn
    end
  end
end