module TicTacToe
  # TicTacToe::Board encaplsulates all methods needed to maintian the state of a
  # Tic Toe board.These include methods for creating the board and marking a
  # position on the board. Contains the logic for a non huhman player to mark a
  # position on the board.
  class Board
    attr_accessor :board

    # Creates a new board in which each space is filled with a specified marker.
    # if no parameter is given each position is filled with a single space(' ').
    # +marker+:: the marker with which to fill the board. If no value is given,
    # the marker defaults to ' '.
    def initialize(marker = ' ')
      @board = Array.new(3) { Array.new(3) { marker } }
    end

    # Marks specified positions on the board with the specified player's marker.
    # +player+::The player who is marking each position, and who's marker will
    # be displayed on the board.
    # +positions+:: Each position that is to be marker witht the players marker.
    # Valid positions start at the upper left hand corner of the board and are
    # 1-9.
    def mark(player, *positions)
      if player.is_a? NonHumanPlayer
        row, column = find_best_position(player)
        @board[row][column] = player.marker
      else
        positions.each do |position|
          column, row = Board.retrieve_position(position)
          fail OverwriteError unless @board[row][column] == ' '
          @board[row][column] = player.marker
        end
      end
    end

    # Finds the best position for a player to mark. Does not take into account
    # the other players possibility of winning. Will return a winning position
    # if possible. If not, it will return a position located in a row in which
    # there is a merker for the given player, and two spaces. If this is not
    # possible, it will return the first position with a space and a merker for
    # the given player. If all else fails, it will return the first open space
    # it encounters.
    # +player+:: the player for which to find the best position
    def find_best_position(player)
      find_winning_position(player) ||
        find_single_same_marker(player) ||
        find_same_marker(player) ||
        find_any_space
    end

    # Finds the first possible winning position for the given player. Returns
    # false if there are no winning positions.
    # +player+:: The player for which to find the winning position.
    def find_winning_position(player)
      rows.each_with_index do |row, index|
        # returns an array of index values for ' ' in @board
        if Board.two_in_scope(row, player) && Board.space_in_scope(row)
          return [index, row.index(' ')]
        end
      end
      columns.each_with_index do |column, index|
        # index values swapped for columns because of the way board#columns is
        # defined
        if Board.two_in_scope(column, player) && Board.space_in_scope(column)
          return [column.index(' '), index]
        end
      end
      diagonals.each_with_index do |diagonal, index|
        if Board.two_in_scope(diagonal, player) && Board.space_in_scope(diagonal)
          # ternary if statement necessary because of way board#diagonals is
          # defined
          return [
            index == 0 ?
            diagonal.index(' ') : (diagonal.index(' ') - 2).abs,
            diagonal.index(' ')]
        end
      end
      false
    end

    # Finds the first position located in a row in which the givern player's
    # marker appears, and there are two available positions. Returns false if
    # there are no such positions.
    # +player+:: The player for which to find the position.
    def find_single_same_marker(player)
      rows.each_with_index do |row, index|
        if Board.two_spaces_in_scope(row) && Board.one_in_scope(row, player)
          return [index, row.index(' ')]
        end
      end
      columns.each_with_index do |column, index|
        if Board.two_spaces_in_scope(column) && Board.one_in_scope(column, player)
          return [column.index(' '), index]
        end
      end
      diagonals.each_with_index do |diagonal, index|
        if Board.one_in_scope(diagonal, player) && Board.two_spaces_in_scope(diagonal)
          return [
            index == 0 ?
            diagonal.index(' ') : (diagonal.index(' ') - 2).abs,
            diagonal.index(' ')]
        end
      end
      false
    end

    # Finds the first position located in a row in which the fiven player's
    # marker appears. Returns false if there is no such position.
    # +player+:: The player for which to find the position.
    def find_same_marker(player)
      rows.each_with_index do |row, index|
        if Board.space_in_scope(row) && Board.one_in_scope(row, player)
          return [index, row.index(' ')]
        end
      end
      columns.each_with_index do |column, index|
        if Board.space_in_scope(column) && Board.one_in_scope(column, player)
          return [column.index(' '), index]
        end
      end
      diagonals.each_with_index do |diagonal, index|
        if Board.one_in_scope(diagonal, player) && Board.space_in_scope(diagonal)
          return [
            index == 0 ?
            diagonal.index(' ') : (diagonal.index(' ') - 2).abs,
            diagonal.index(' ')]
        end
      end
      false
    end

    # Returns the index values of the first available (e.g.' ') position in a
    # board. Returns false if the board is full.
    def find_any_space
      @board.each_with_index { |row, index| row.each_with_index { |position, row_index| return [index, row_index] if position == ' ' } }
      false
    end

    # Returns true if there are exactly two markers equal to the given player's
    # marker in the scope (e.g. row, column, diagonal)
    # +scope+::The collection in which to search in. A row, column, or diagonal.
    # +player+::The player whose marker is being matched.
    def self.two_in_scope(scope, player)
      return true if scope.count { |marker| marker == player.marker } == 2
      false
    end

    # Returns true if there is exactly one marker equal to the given player's
    # marker in scope.
    # +scope+::The collection in which to search in. A row, column, or diagonal.
    # +player+::The player whose marker is being matched.
    def self.one_in_scope(scope, player)
      return true if scope.count { |marker| marker == player.marker } == 1
      false
    end

    # Returns true if there is exactly one available positioni in scope.
    # +scope+::The collection in which to search in. A row, column, or diagonal.
    def self.space_in_scope(scope)
      return true if scope.count { |marker| marker == ' ' } == 1
      false
    end
    def self.two_spaces_in_scope(scope)
      return true if scope.count { |marker| marker == ' ' } == 2
      false
    end

    # Maps user input for a position to the actual index values in @board for
    # the position.
    # +position+::The position (1-9) given by the user.
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

    # outputs the board to the console.
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

    # returns @board -- an array containing three subarrays. Each subarray
    # contains the values for a row from @board.
    def rows
      @board
    end

    # Returns an array containing three subarrays. Each subarray contains the
    # values for a column from @board.
    def columns
      [
        [@board[0][0], @board[1][0], @board[2][0]],
        [@board[0][1], @board[1][1], @board[2][1]],
        [@board[0][2], @board[1][2], @board[2][2]]
      ]
    end

    # Returns an array containing two subarrays. Each subarray contains the
    # values for a diagonal from @board.
    def diagonals
      [
        [@board[0][0], @board[1][1], @board[2][2]],
        [@board[2][0], @board[1][1], @board[0][2]]
      ]
    end
  end
end
