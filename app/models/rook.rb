class Rook < Piece
  def valid_move?(x, y)
    
    # If move is horizontal and not obstructed
    if position_y == y && !self.is_obstructed?(x, y)
      return true
    end 

    # If move is vertical and not obstructed
    if position_x == x && !self.is_obstructed?(x, y)
      return true
    end

    # All other casees
    return false
  end
end