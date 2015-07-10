module Mastermind
  class CodeLengthError < StandardError
    def message
      'The code must be 4 values separated by spaces.'
    end
  end
  class CodeUniqueError < StandardError
    def message
      "Each color must be unique."
    end
  end
  class InvalidColorError < StandardError
    def message
      "One or more of the colors you have chosen are not available."
    end
  end
end
