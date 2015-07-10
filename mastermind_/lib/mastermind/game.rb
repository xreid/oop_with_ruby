module Mastermind
  class Game
    attr_reader :code, :all_colors, :guessed_code, :clues, :type, :play_again
    SIZE = 4
    DOT_1 = '⬤'
    DOT_2 = '●'

    def initialize(game_type = 1)
      @type = game_type
      @code = []
      @guessed_code = []
      @play_again = false
      @won = false
      @attempts = 0
      colors
      clues
    end

    def play
      welcome
      instructions
      if @type <= 1
        generate_code
        while @attempts < 12 && !@won
          get_player_guess
          @attempts += 1
          check_code
          draw
        end
      else
        get_player_code
        while @attempts < 12 && !@won
          guess_code
          @attempts += 1
          check_code
          draw
          sleep 0.33
        end
      end
      game_over
    end

    def available_colors
      puts 'Available colors:'
      @all_colors.each_with_index do |color, index|
        print "#{index + 1}:#{'⬤  '.colorize(color)}"
      end
      puts ''
    end

    def check_code
      if @code == @guessed_code
        @clues.each do |clue|
          clue[:color] = true
          clue[:placement] = true
        end
        @won = true
      else
        @guessed_code.each_with_index do |guess_color, guess_index|
          @code.each_with_index do |actual_color, actual_index|
            if guess_index == actual_index
              @clues[guess_index][:swapped] = false
              if guess_color == actual_color
                @clues[guess_index][:color] = true
                @clues[guess_index][:placement] = true
              elsif @code.include? guess_color
                @clues[guess_index][:color] = true
                @clues[guess_index][:placement] = false
              else
                @clues[guess_index][:color] = false
                @clues[guess_index][:placement] = false
              end
            end
          end
        end
      end
      @clues
    end

    def clues
      @clues = []
      4.times { @clues << { color: false, placement: false, swapped: true } }
    end

    def colors
      @all_colors = String.colors
      @all_colors.delete(:black)
      @all_colors.delete_if { |color| color.to_s.include? 'white' }
    end

    def draw
      draw_board
      draw_clues
      @guessed_code = [] if @type <= 1
      puts ''
    end

    def draw_board
      @guessed_code.each { |color| print DOT_1.colorize(color) + '   ' }
      print ' '
    end

    def draw_clues
      @clues.each do |clue|
        if clue[:color] && clue[:placement]
          print DOT_2.light_green + '  '
        elsif clue[:color]
          print DOT_2.light_cyan + '  '
        else
          print DOT_2.light_black + '  '
        end
      end
    end

    def game_over
      print 'Game over. '
      if @type <= 1
        if @won
          puts "You Won!\nYou cracked the code in #{@attempts} tries!"
        else
          puts 'You Lost.'
        end
      else
        if @won
          puts "The computer cracked your code in #{@attempts} tries!"
        else
          puts 'The computer could not crack your code!'
        end
      end
      puts 'Play again? y/n'
      input = gets.strip.downcase
      if input == 'y'
        @play_again = true
      elsif input == 'n'
        puts 'Thanks for playing!'
      end
    end

    def generate_code
      @code = @all_colors.sample(SIZE)
    end

    def get_player_code
      puts "\nCreate your code by entering the number value of four colors"\
      "separated by spaces. (e.g. '1 2 3 4' for grey burgundy red green)."
      begin
        input = gets.chomp.split.map!(&:to_i)
        fail CodeLengthError if input.size != 4
        fail CodeUniqueError if input.uniq.size != 4
        fail InvalidColorError if input.any? { |color| color < 1 || color > @all_colors.size }
      rescue StandardError => e
        puts e.message.light_red
        retry
      end
      input.each { |index| @code << @all_colors[index - 1] }
      print "\nYour Seceret Code: "
      @code.each { |color| print DOT_1.colorize(color) + '  ' }
      puts "\n"
    end

    def get_player_guess
      begin
        input = gets.chomp.split.map!(&:to_i)
        fail CodeLengthError if input.size != 4
        fail CodeUniqueError if input.uniq.size != 4
        fail InvalidColorError if input.any? { |color| color < 1 || color > @all_colors.size }
      rescue StandardError => e
        puts e.message.light_red
        retry
      end
      input.each { |index| @guessed_code << all_colors[index - 1] }
    end

    def guess_code
      # If this is the first guess choose 4 random colors
      if @attempts == 0
        @guessed_code = @all_colors.sample(SIZE)
        @all_colors.delete_if { |color| @guessed_code.include?(color) }
      else
        @guessed_code.each_with_index do |color, color_index|
          # Remove the current color from the collection of all colors so it can
          # not be chosen again.
          @all_colors.delete(color)
          # skip colors in the correct position
          if @clues[color_index][:placement]
            next
          # If the current color appears in the code but is not in the correct
          # location swap it with a another color in the same situation.
          elsif @clues[color_index][:color]
            @guessed_code.each_with_index do |_swap_color, swap_index|
              # only swap colors if they have not already been swapped in the
              # current call to guess_code
              # swapped is set to false in Game#check_code
              if !@clues[swap_index][:placement] && @clues[swap_index][:color] && color_index != swap_index && !@clues[swap_index][:swapped]
                @guessed_code[color_index], @guessed_code[swap_index] =
                @guessed_code[swap_index], @guessed_code[color_index]
                @clues[color_index][:swapped] = true
                @clues[swap_index][:swapped] = true
              end
            end
          else
            @guessed_code[color_index] = @all_colors.pop
          end
        end
      end
    end

    def instructions
      if @type <= 1
        puts 'Enter the corresponding numbers for the color you would like to'\
         "select separated by spaces. (e.g. '1 2 3 4')\nIf you have selected a"\
         'correct color, a cyan dot will appear on the right. If you have'\
         'chosen a correct color and position, a green dot will appear.'\
         'Otherwise, a grey dot appears'
      end
      available_colors
    end

    def welcome
      puts "\nWelcome to Command Line Mastermind!\nEnter 1 to solve a"\
      'computer generated code, or enter 2 to watch the computer solve a code'\
      'you create.'
      @type = gets.strip.to_i
    end
  end
end
