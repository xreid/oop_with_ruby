module TicTacToe
  class OverwriteError < StandardError
    def message
      'This position is already marked. Please choose another.'
    end
  end
  class IndexError < StandardError
    def message
      'Position out of range. Position must be from 1-9.'
    end
  end
  class DuplicateError < StandardError
    def message
      'This name or mark is already taken. Please choose another.'
    end
  end
  class EmptyStringError < StandardError
    def message
      'Name or mark cannot be blank.'
    end
  end
end
