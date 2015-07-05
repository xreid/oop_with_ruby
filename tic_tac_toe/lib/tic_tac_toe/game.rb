module TicTacToe
  # Emcapsulates all methods required to start a game of Tic Tac Toe. Includes
  # methods to query players for input and continue the game until it is over.
  class Game
    attr_accessor :player_1, :player_2

    # Creates a new game with  a board and calls Game#welcome.
    # +marker+::The value to populate the board with. Deaults to ' '.
    def initialize(marker = ' ')
      @board = Board.new(marker)
      welcome
    end

    # Prints a welcome message to the console.
    def welcome
      puts 'Welcome to Command Line Tic Tac Toe!'
      puts 'Two players choose a name and marker (x, o, q, etc.) and start playing.'
    end

    # Asks the user to input 1 for single player or 2 for two player. Anything
    # <= 1 is single player and eveything else is two player.
    def mode
      puts 'Enter 1 for single player. 2 for two players.'
      gets.strip.to_i
    end

    # Prints instructions to the console
    def self.instructions
      puts 'select a position to mark it as yours'
      puts ' 1 | 2 | 3 '
      puts '---+---+---'
      puts ' 4 | 5 | 6 '
      puts '---+---+---'
      puts ' 7 | 8 | 9 '
    end

    # Queries the players for a name and marker and allows players to choose
    # single or two player.
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

      if mode <= 1
        # create a NonHumanPlayer if the user chooses single player.
        # if the user has selected NonHumanPlayer's default marker or name, use
        # an alternate.
        c_name = p1_name == 'computer' ? 'Reptar' : 'computer'
        c_marker = p1_marker == 'c' ? 'x' : 'c'
        @player_2 = NonHumanPlayer.new(c_name, c_marker)
      else
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
    end

    # Starts the game. The user is prompted to choose position their choice is
    # processed and the board is updated. This continues to happen until
    # Game#over returns true.
    def play
      puts "#{@player_1.name} vs #{@player_2.name}"
      current_player = @player_1
      other_player = @player_2

      until over?
        @board.draw

        # Board#mark will handle the logic for a NonHumanPlayer
        if current_player.is_a? NonHumanPlayer
          @board.mark(current_player)
          @board.draw
          puts "\n"
        else
          print "#{current_player.name}, choose a square "
          begin
            selection = gets.strip.to_i
            @board.mark(current_player, selection)
          rescue StandardError => e
            puts e.message
            retry
          end
        end
        if winner
          @board.draw
          puts "Game over. #{winner} wins!"
          return
        end
        # swap players
        current_player, other_player = other_player, current_player
      end
      puts winner ? "Game over. #{winner} wins!" : "Game over. It's a draw."
    end

    # Returns once the board is full
    def over?
      return true if @board.board.all? { |row| row.none? {  |element| element == ' ' } }
      false
    end

    # Returns the marker of the winning player
    def winner
      @board.rows.each do |row|
        return row[0] if row.all? { |element| element == row[0] && element != ' ' }
      end
      @board.columns.each do |column|
        return column[0] if column.all? { |element| element == column[0] && element != ' ' }
      end
      @board.diagonals.each do |diagonal|
        return diagonal[0] if diagonal.all? { |element| element == diagonal[0] && element != ' ' }
      end
      nil
    end
  end
end
