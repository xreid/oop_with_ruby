module TicTacToe
  # Raised when a player attempts to mark a position already containing a mark.
  class OverwriteError < StandardError
    def message
      'This position is already marked. Please choose another.'
    end
  end

  # Raised when a player attempts to mark a position > 9 or < 1.
  class IndexError < StandardError
    def message
      'Position out of range. Position must be from 1-9.'
    end
  end

  # Raised when a player attempts to create a duplicate name or marker.
  class DuplicateError < StandardError
    def message
      'This name or mark is already taken. Please choose another.'
    end
  end

  # Raised when a player attampts to make their name or marker empty or only
  # spaces.
  class EmptyStringError < StandardError
    def message
      'Name or mark cannot be blank.'
    end
  end
  # Raised when a player attampts to make their name or marker empty or only
  # spaces.
  class MaxLengthError < StandardError
    def message
      'Marker must be 1 character.'
    end
  end
end
