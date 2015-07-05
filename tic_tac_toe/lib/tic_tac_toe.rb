require_relative 'tic_tac_toe//version'
require_relative 'tic_tac_toe/player.rb'
require_relative 'tic_tac_toe/non_human_player.rb'
require_relative 'tic_tac_toe/board.rb'
require_relative 'tic_tac_toe/game.rb'
require_relative 'tic_tac_toe/exceptions.rb'

module TicTacToe
  # comment out to run tests
  game = Game.new
  game.get_players
  Game.instructions
  game.play
end
