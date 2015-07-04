require 'spec_helper'

module TicTacToe
  describe '#initialize' do
    game_board = Board.new.board
    it 'generates a 3x3 board' do
      expect(game_board.size).to eq 3
      expect(game_board[0].size).to eq 3
      expect(game_board[1].size).to eq 3
      expect(game_board[2].size).to eq 3
    end
  end

  describe '#mark' do
    game = Board.new
    it 'marks a position with the specified marker' do
      game.mark(1, :x)
      expect(game.board[0][0]).to eq :x
    end
    it 'does not overwrite existing marks' do
      expect { game.mark(1, :x) }.to raise_error(OverwriteError)
    end
  end

  describe '#retrieve_position' do
    it 'returns the correct index for the position (1-9)' do
      game_board = Board.new.board
      1.upto(9) do |i|
        column, row = Board.retrieve_position(i)
        game_board[row][column] = i
      end
      expect(game_board).to eq [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    end

    it 'raises an error for out of range indices' do
      expect { Board.retrieve_position(10) }.to raise_error(IndexError)
      expect { Board.retrieve_position(0) }.to raise_error(IndexError)
    end
  end

  describe "#draw" do
    it "draws a tic tac toe board" do
      game = Board.new()
      row = "   |   |   \n"
      divider = "---+---+---\n"
      expect{game.draw}.to output("#{row}#{divider}#{row}#{divider}#{row}").to_stdout
    end
  end
end
