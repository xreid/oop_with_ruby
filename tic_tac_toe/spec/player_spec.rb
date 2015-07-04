require 'spec_helper'

module TicTacToe
  describe '#initialize' do
    it "assigns a player's name and marker" do
      ragnar = Player.new('Ragnar', :r)
      expect(ragnar.name).to eq 'Ragnar'
      expect(ragnar.marker).to eq :r
    end
  end
end
