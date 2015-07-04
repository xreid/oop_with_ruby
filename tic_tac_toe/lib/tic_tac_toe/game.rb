module TicTacToe
  class Game
    attr_accessor :player_1, :player_2
    def initialize(marker = ' ')
      @board = Board.new(marker)
      welcome
    end

    def welcome
      puts 'Welcome to Command Line Tic Tac Toe!'
      puts 'Two players choose a name and marker (x, o, q, etc.) and start playing.'
    end

    def self.instructions
      puts 'select a position to mark it as yours'
      puts ' 1 | 2 | 3 '
      puts '---+---+---'
      puts ' 4 | 5 | 6 '
      puts '---+---+---'
      puts ' 7 | 8 | 9 '
    end

    def get_players
      begin
        print "\nPlayer 1\n\tname: "
        p1_name = gets.strip
        fail EmptyStringError if p1_name == ''
      rescue StandardError => e
        puts e.message
        retry
      end

      begin
        print "\n\tmarker: "
        p1_marker = gets.strip
        fail EmptyStringError if p1_marker == ''
      rescue StandardError => e
        puts e.message
        retry
      end
      @player_1 = Player.new(p1_name, p1_marker)

      begin
        print "Player 2\n\tname: "
        p2_name = gets.strip
        fail DuplicateError if p2_name == p1_name || p2_name == p1_marker
        fail EmptyStringError if p2_name.strip == ''
      rescue StandardError => e
        puts e.message
        p2_name = ''
        retry
      end

      begin
        print "\n\tmarker: "
        p2_marker = gets.strip
        fail DuplicateError if p2_marker == p1_name || p2_marker == p1_marker
        fail EmptyStringError if p2_marker.strip == ''

      rescue StandardError => e
        puts e.message
        p2_marker = ''
        retry
      end
      @player_2 = Player.new(p2_name, p2_marker)
    end

    def play
      puts "#{@player_1.name} vs #{@player_2.name}"
      current_player = @player_1
      other_player = @player_2

      until over?
        @board.draw
        print "#{current_player.name}, choose a square "


        begin
          selection = gets.strip.to_i
          @board.mark(selection, current_player.marker)
        rescue StandardError => e
          puts e.message


          retry
        end

        if winner
          @board.draw
          puts "Game over. #{winner} wins!"
          return
        end

        current_player, other_player = other_player, current_player
      end
      puts winner ? "Game over. #{winner} wins!" : "Game over. It's a draw."
      nil
    end

    def over?
      return true if @board.board.all? { |row| row.none? {  |element| element == ' ' } }
      false
    end

    def winner
      rows.each do |row|
        return row[0] if row.all? { |element| element == row[0] && element != ' ' }
      end
      columns.each do |column|
        return column[0] if column.all? { |element| element == column[0] && element != ' ' }
      end
      diagonals.each do |diagonal|
        return diagonal[0] if diagonal.all? { |element| element == diagonal[0] && element != ' ' }
      end
      nil
    end

    private

    def rows
      @board.board
    end

    def columns
      [
        [@board.board[0][0], @board.board[1][0], @board.board[2][0]], [@board.board[0][1], @board.board[1][1], @board.board[2][1]],
        [@board.board[0][2], @board.board[1][2], @board.board[2][2]]
      ]
    end

    def diagonals
      [
        [@board.board[0][0], @board.board[1][1], @board.board[2][2]],
        [@board.board[2][2], @board.board[1][1], @board.board[0][0]]
      ]
    end
  end
end
