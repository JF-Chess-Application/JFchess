class King < Piece
  def valid_move?(x, y)
    if self.is_obstructed?(x, y)
      return false
    end

    up_one = position_y + 1
    down_one = position_y - 1
    left_one = position_x - 1
    right_one = position_x + 1

    # check if it's a valid horizontal move
    if y == position_y && (x == right_one || x == left_one)
      return true
    # check if it's a valid vertical move
    elsif x == position_x && (y == up_one || y == down_one)
      return true
    # check if it's a valid diagonal move
    elsif (x == right_one && y == up_one) || (x == left_one && y == up_one) || (x == left_one && y == down_one) || (x == right_one && y == down_one)
      return true
    else
      return false
    end
  end
end