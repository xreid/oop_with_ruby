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
    player = Player.new('ragnar', 'r')
    it 'marks a position with the specified marker' do
      game.mark(1, player)
      expect(game.board[0][0]).to eq 'r'
    end
    it 'does not overwrite existing marks' do
      expect { game.mark(1, player) }.to raise_error(OverwriteError)
    end
  end

  describe 'find_winning_position_position' do
    player = Player.new('ragnar', 'r')
    it 'finds the winning position in a row' do
      board = Board.new
      board.mark(1, player)
      board.mark(2, player)
      expect(board.find_winning_position(player)).to eq [0, 2]
      board = Board.new
      board.mark(9, player)
      board.mark(8, player)
      expect(board.find_winning_position(player)).to eq [2, 0]
    end
    it 'finds the winning position in a column' do
      board = Board.new
      board.mark(1, player)
      board.mark(4, player)
      expect(board.find_winning_position(player)).to eq [2, 0]
      board = Board.new
      board.mark(2, player)
      board.mark(8, player)
      expect(board.find_winning_position(player)).to eq [1, 1]
    end
    it 'finds the winning position in a diagonal' do
      board = Board.new
      board.mark(3, player)
      board.mark(5, player)
      expect(board.find_winning_position(player)).to eq [2, 0]
      board = Board.new
      board.mark(1, player)
      board.mark(5, player)
      expect(board.find_winning_position(player)).to eq [2, 2]
    end
    context 'when there is no winning position' do
      it 'returns false' do
        expect(Board.new.find_winning_position(player)).to be_falsey
        expect(Board.new('x').find_winning_position(player)).to be_falsey
      end
    end
  end

  describe '#find_single_same_marker' do
    player = Player.new('ragnar', 'r')
    it 'returns the first empty position next to an equal marker' do
      board = Board.new
      board.mark(1, player)
      expect(board.find_single_same_marker(player)).to eq [0, 1]
      board.mark(2, player)
      expect(board.find_single_same_marker(player)).to eq [1, 0]
      board.mark(4, player)
      expect(board.find_single_same_marker(player)).to eq [1, 1]
    end
    context "when no single marker == the player's marker" do
      it 'returns false' do
        board = Board.new
        board.mark(1, player)
        board.mark(2, player)
        board.mark(3, player)
        board.mark(4, player)
        board.mark(5, player)
        board.mark(7, player)
        board.mark(9, player)
        expect(board.find_single_same_marker(player)).to be_falsey
      end
    end
  end

  describe '#find_same_marker' do
    player = Player.new('ragnar', 'r')
    other_player = Player.new('lothbrok', 'l')
    it "returns the first empty space next to a marker == player's marker" do
      board = Board.new
      board.mark(1, player)
      board.mark(2, other_player)
      expect(board.find_same_marker(player)).to eq [0, 2]
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
      player = Player.new('ragnar', 'r')
      expect(Board.two_in_scope(%w(x r r), player)).to be_truthy
      expect(Board.two_in_scope(['x', ' ', 'r'], player)).to be_falsey
    end
  end

  describe '#space_in_scope' do
    it 'returns true if any position in scope is empty' do
      expect(Board.space_in_scope(%w(x r r))).to be_falsey
      expect(Board.space_in_scope(['x', ' ', 'r'])).to be_truthy
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

  describe '#draw' do
    it 'draws a tic tac toe board' do
      game = Board.new
      row = "   |   |   \n"
      divider = "---+---+---\n"
      expect { game.draw }.to output("#{row}#{divider}#{row}#{divider}#{row}").to_stdout
    end
  end
end
