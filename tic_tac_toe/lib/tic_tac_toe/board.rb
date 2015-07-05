module TicTacToe
  class Board
    attr_accessor :board

    def initialize(marker = ' ')
      @board = Array.new(3) { Array.new(3) { marker } }
    end

    def mark(position = nil, player)
      if player.is_a? NonHumanPlayer
        row, column = find_best_position(player)
        @board[row][column] = player.marker
      else
        column, row = Board.retrieve_position(position)
        fail OverwriteError unless @board[row][column] == ' '
        @board[row][column] = player.marker
      end
    end

    def find_best_position(player)
      find_winning_position(player) || find_single_same_marker(player) || find_same_marker(player) || find_any_space
    end

    def find_winning_position(player)
      rows.each_with_index { |row, index| return [index, row.index(' ')] if Board.two_in_scope(row, player) && Board.space_in_scope(row) }
      columns.each_with_index { |column, index| return [column.index(' '), index] if Board.two_in_scope(column, player) && Board.space_in_scope(column) }
      diagonals.each_with_index { |diagonal, index| return [index == 0 ? diagonal.index(' ') : (diagonal.index(' ') - 2).abs, diagonal.index(' ')] if Board.two_in_scope(diagonal, player) && Board.space_in_scope(diagonal) }
      false
    end

    def find_single_same_marker(player)
      rows.each_with_index do |row, index|
        return [index, row.index(' ')] if Board.two_spaces_in_scope(row) && Board.one_in_scope(row, player)
      end
      columns.each_with_index do |column, index|
        return [column.index(' '), index] if Board.two_spaces_in_scope(column) && Board.one_in_scope(column, player)
      end
      diagonals.each_with_index do |diagonal, index|
        return [index == 0 ? diagonal.index(' ') : (diagonal.index(' ') - 2).abs, diagonal.index(' ')] if Board.one_in_scope(diagonal, player) && Board.two_spaces_in_scope(diagonal)
      end
      false
    end

    def find_same_marker(player)
      rows.each_with_index do |row, index|
        return [index, row.index(' ')] if Board.space_in_scope(row) && Board.one_in_scope(row, player)
      end
      columns.each_with_index do |column, index|
        return [column.index(' '), index] if Board.space_in_scope(column) && Board.one_in_scope(column, player)
      end
      diagonals.each_with_index do |diagonal, index|
        return [index == 0 ? diagonal.index(' ') : (diagonal.index(' ') - 2).abs, diagonal.index(' ')] if Board.one_in_scope(diagonal, player) && Board.space_in_scope(diagonal)
      end
      false
    end

    def find_any_space
      @board.each_with_index { |row, index| row.each_with_index { |position, row_index| return [index, row_index] if position == ' ' }}
      false
    end

    def self.two_in_scope(scope, player)
      return true if scope.count { |marker| marker == player.marker } == 2
      false
    end

    def self.one_in_scope(scope, player)
      return true if scope.count { |marker| marker == player.marker } == 1
      false
    end

    def self.space_in_scope(scope)
      return true if scope.count { |marker| marker == ' ' } == 1
      false
    end
    def self.two_spaces_in_scope(scope)
      return true if scope.count { |marker| marker == ' ' } == 2
      false
    end

    def self.retrieve_position(position)
      fail IndexError unless position.between?(1, 9)
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

    def rows
      @board
    end

    def columns
      [
        [@board[0][0], @board[1][0], @board[2][0]],
        [@board[0][1], @board[1][1], @board[2][1]],
        [@board[0][2], @board[1][2], @board[2][2]]
      ]
    end

    def diagonals
      [
        [@board[0][0], @board[1][1], @board[2][2]],
        [@board[2][0], @board[1][1], @board[0][2]]
      ]
    end
  end
end
