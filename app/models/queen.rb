class Queen < Piece
  def valid_move?(x, y)

    # If move is horizontal and not obstructed
    if position_y == y && !self.is_obstructed?(x, y)
      return true
    end

    # If move is vertical and not obstructed
    if position_x == x && !self.is_obstructed?(x, y)
      return true
    end

    # If move is diagonal and not obstructed
    diff_x = (position_x - x).abs
    diff_y = (position_y - y).abs
    if diff_x == diff_y && !self.is_obstructed?(x, y)
      return true
    end

    # All other cases
    return false
  end
end