class King < Piece
  def valid_move?(x, y)
    # check if it's a valid horizontal move
    if y == position_y && (x == position_x + 1 || x == position_x - 1)
      return true
    # check if it's a valid vertical move
    elsif x == position_x && (y == position_y + 1 || y == position_y - 1)
      return true
    # check if it's a valid diagonal move
    elsif (x == position_x + 1 && y == position_y +1) || (x == position_x - 1 && y == position_y + 1) || (x == position_x - 1 && y == position_y - 1) || (x == position_x + 1 && y == position_y - 1)
      return true
    # if none of the above, false
    else
      return false
    end
end
