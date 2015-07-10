module Mastermind
  describe '#initialize' do
    game = Game.new
    context 'without any arguments' do
      it 'sets the game type to 1' do
        expect(game.type).to eq 1
      end
    end
    context 'with an argument > 1' do
      it 'sets the game type to 2' do
        expect(Game.new(2).type).to eq 2
      end
    end
  end

  describe '#generate_code' do
    it 'sets the code to array of 4 random colors' do
      game = Game.new
      game.generate_code
      expect(game.code.size).to eq 4
    end
  end

  describe 'get_player_guess' do
    it "sets the guessed code equal to the player's input" do
      game = Game.new
      game.stub(:gets) { '1 2 3 4' }
      game.get_player_guess
      expect(game.guessed_code).to eq [:light_black, :red, :light_red, :green]
    end
  end

  describe '#check_code' do
    it "returns 'won' if the guessed code is correct" do
      game = Game.new
      game.stub(:gets) { '1 2 3 4' }
      game.get_player_guess
      game.generate_code
      expect(game.check_code.size).to eq 4
    end
  end

  describe '#get_player_code' do
    it "sets the code to the player's input" do
      game = Game.new(2)
      game.stub(:gets) { '1 2 3 4' }
      game.get_player_code
      expect(game.code).to eq [:light_black, :red, :light_red, :green]
    end
  end
end
