require 'spec_helper'

module TicTacToe
  drake = Player.new('Drake', 'D')
  josh = Player.new('Josh', 'J')

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
    board = Board.new
    it 'marks a position with the specified marker' do
      board.mark(drake, 1)
      expect(board.board[0][0]).to eq 'D'
    end
    it 'does not overwrite existing marks' do
      expect { board.mark(drake, 1) }.to raise_error(OverwriteError)
    end
  end

  describe 'find_winning_position_position' do
    it 'finds the winning position in a row' do
      board = Board.new
      board.mark(drake, 1, 2)
      expect(board.find_winning_position(drake)).to eq [0, 2]
      board = Board.new
      board.mark(drake, 8, 9)
      expect(board.find_winning_position(drake)).to eq [2, 0]
    end
    it 'finds the winning position in a column' do
      board = Board.new
      board.mark(drake, 1, 4)
      expect(board.find_winning_position(drake)).to eq [2, 0]
      board = Board.new
      board.mark(drake, 2, 8)
      expect(board.find_winning_position(drake)).to eq [1, 1]
    end
    it 'finds the winning position in a diagonal' do
      board = Board.new
      board.mark(drake, 3, 5)
      expect(board.find_winning_position(drake)).to eq [2, 0]
      board = Board.new
      board.mark(drake, 1, 5)
      expect(board.find_winning_position(drake)).to eq [2, 2]
    end
    context 'when there is no winning position' do
      it 'returns false' do
        expect(Board.new.find_winning_position(drake)).to be_falsey
        expect(Board.new('x').find_winning_position(drake)).to be_falsey
      end
    end
  end

  describe '#find_single_same_marker' do
    it 'returns the first empty position next to an equal marker' do
      board = Board.new
      board.mark(drake, 1)
      expect(board.find_single_same_marker(drake)).to eq [0, 1]
      board.mark(drake, 2)
      expect(board.find_single_same_marker(drake)).to eq [1, 0]
      board.mark(drake, 4)
      expect(board.find_single_same_marker(drake)).to eq [1, 1]
    end
    context "when no single marker == the player's marker" do
      it 'returns false' do
        board = Board.new
        board.mark(drake, 1, 2, 3, 4, 5, 7, 9)
        expect(board.find_single_same_marker(drake)).to be_falsey
      end
    end
  end

  describe '#find_same_marker' do
    it "returns the first empty space next to a marker == player's marker" do
      board = Board.new
      board.mark(drake, 1)
      board.mark(josh, 2)
      expect(board.find_same_marker(drake)).to eq [0, 2]
    end
  end

  describe '#find_any_space' do
    it 'returns the first available position' do
      expect(Board.new.find_any_space).to eq [0, 0]
    end
    context 'when there are no available spaces' do
      it 'returns false' do
        expect(Board.new('x').find_any_space).to be_falsey
      end
    end
  end

  describe '#two_in_scope' do
    it "returns true if two marks == the player's mark" do
      expect(Board.two_in_scope(%w(D D J), drake)).to be_truthy
      expect(Board.two_in_scope(['J', 'D', ' J'], drake)).to be_falsey
    end
  end

  describe '#space_in_scope' do
    it 'returns true if any position in scope is empty' do
      expect(Board.space_in_scope(%w(D D D))).to be_falsey
      expect(Board.space_in_scope(['J', ' ', 'D'])).to be_truthy
    end
  end

  describe '#retrieve_position' do
    it 'returns the correct index for the position (1-9)' do
      board = Board.new.board
      1.upto(9) do |i|
        column, row = Board.retrieve_position(i)
        board[row][column] = i
      end
      expect(board).to eq [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    end

    it 'raises an error for out of range indices' do
      expect { Board.retrieve_position(10) }.to raise_error(IndexError)
      expect { Board.retrieve_position(0) }.to raise_error(IndexError)
    end
  end

  describe '#draw' do
    it 'draws a tic tac toe board' do
      game = Board.new
      row = "   |   |   \n"
      divider = "---+---+---\n"
      expect { game.draw }.to output("#{row}#{divider}#{row}#{divider}#{row}").to_stdout
    end
  end
end
