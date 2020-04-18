require_relative 'bank.rb'
require_relative 'card.rb'
require_relative 'player.rb'
require_relative 'user_player.rb'
require_relative 'computer_player.rb'
require_relative 'console_ui.rb'
require_relative 'game.rb'

game = Game.new(ConsoleUI)
game.start