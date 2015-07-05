module TicTacToe
  # A player is given a name and a marker to identify each position chosen by
  # the player on the board.
  class Player
    attr_reader :name, :marker
    def initialize(name, marker)
      @name = name
      @marker = marker
    end
  end
end
