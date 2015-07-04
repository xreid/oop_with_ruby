module TicTacToe
  class Board
    attr_accessor :board

    def initialize(marker = " ")
      @board = Array.new(3) { Array.new(3) { marker } }
    end

    def mark(position, marker)
      column, row = Board.retrieve_position(position)
      raise OverwriteError unless @board[row][column] == " "
      @board[row][column] = marker
    end

    def self.retrieve_position(position)
      raise IndexError unless position.between?(1, 9)
      case position
      when 1 then [0, 0]
      when 2 then [1, 0]
      when 3 then [2, 0]
      when 4 then [0, 1]
      when 5 then [1, 1]
      when 6 then [2, 1]
      when 7 then [0, 2]
      when 8 then [1, 2]
      when 9 then [2, 2]
      end
    end

    #  1 | 2 | 3
    # ---+---+---
    #  4 | 5 | 6
    # ---+---+---
    #  7 | 8 | 9
    def draw
      board.each_with_index do |row, row_index|
        row.each_with_index do |element, element_index|
          if row_index != 2
            print element_index == 2 ? " #{element} \n" : " #{element} |"
          else
            print element_index == 2 ? " #{element} \n" : " #{element} |"
          end
        end
        print "---+---+---\n" unless row_index == 2
      end
    end
  end
end
