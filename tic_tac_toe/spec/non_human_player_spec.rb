module TicTacToe
  describe '#initialize' do
    it "creates a player with name 'computer' and marker 'c'" do
      nhp = NonHumanPlayer.new
      expect(nhp.name).to eq 'computer'
      expect(nhp.marker).to eq 'c'
    end
  end
end
