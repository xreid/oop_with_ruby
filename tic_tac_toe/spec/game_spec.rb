module TicTacToe
  describe '#welcome' do
    it 'outputs a welcome message to the console' do
      message = "Welcome to Command Line Tic Tac Toe!\nTwo players choose a name and marker (x, o, q, etc.) and start playing.\n"
      game = Game.new
      game.stub(:gets) { 'x' }
      expect { game.welcome }.to output(message).to_stdout
    end
  end
  # TODO: refactor test
  describe '#get_players' do
    it 'creates players from console input' do
      game = Game.new
      game.stub(:gets).and_return("x", "x", "2", "z", "z")
      game.get_players
      expect(game.player_1.name).to eq 'x'
      expect(game.player_1.marker).to eq 'x'
      expect(game.player_2.name).to eq 'z'
      expect(game.player_2.marker).to eq 'z'
    end
  end

  describe '#instructions' do
    divider = "---+---+---\n"
    it 'outputs instructions to the console' do
      expect { Game.instructions }.to output("select a position to mark it as yours\n 1 | 2 | 3 \n#{divider} 4 | 5 | 6 \n#{divider} 7 | 8 | 9 \n").to_stdout
    end
  end

  describe '#over' do
    it 'returns true if the board is full' do
      game = Game.new('X')
      expect(game.over?).to be_truthy
    end
    it 'returns false if there are available spaces in the board' do
      game = Game.new
      expect(game.over?).to be_falsey
    end
  end

  describe 'winner' do
    it 'returns the marker of the winning player if there is one' do
      expect(Game.new('x').winner).to eq 'x'
    end
    it 'returns nil if the game ends in a draw' do
      expect(Game.new.winner).to eq nil
    end
  end
end
