module TicTacToe
  # A NonHumanPlayer is given a name and a marker to identify each position
  # chosen by the player on the board. The name defaults to 'computer', while
  # the marker defaults to 'c'.
  class NonHumanPlayer < Player
    def initialize(name = 'computer', marker = 'c')
      super(name, marker)
    end
  end
end
