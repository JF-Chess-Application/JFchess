class Queen < Piece
  # Can move horizontal, vertical, or diagonal for unlimited spaces unless path blocked
  def valid_move?(x,y)

    # Returns false if path is blocked to destiantion space
      return false if path_blocked?(x,y)
    # Returns true if moving diagonally)
    if y == position_y && x == position_x
      return true if y == x
    # Returns true if moving horizontally
    if ((x == position_x > 0) && (y == position_y == 0))
      return true
    end
     # Returns true if moving vertically)
    if ((x == position_x == 0) && (y == position_y > 0)) 
      return true
    end
    # Returns false if not moving horizontally, vertically, or diagonally
    return false
  end
end