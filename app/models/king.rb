class King < Piece
  # def valid_move?(x, y)
  #   if self.is_obstructed?(x, y)
  #     return false
  #   end

    # up_one = position_y + 1
    # down_one = position_y - 1
    # left_one = position_x - 1
    # right_one = position_x + 1

    # # check if it's a valid horizontal move
    # if y == position_y && (x == right_one || x == left_one)
    #   return true
    # # check if it's a valid vertical move
    # elsif x == position_x && (y == up_one || y == down_one)
    #   return true
    # # check if it's a valid diagonal move
    # elsif (x == right_one && y == up_one) || (x == left_one && y == up_one) || (x == left_one && y == down_one) || (x == right_one && y == down_one)
    #   return true
    # # # check if x is valid but not y
    # # elsif (x == position_x || x == right_one || x == left_one) && (y != position_y || y != up_one || y != down_one)
    # #   return false
    # # # check if y is valid but not x
    # # elsif (x != position_x || x != right_one || x != left_one) && (y == position_y || y == up_one || y == down_one)
    # #   return false
    # # # check if both x and y are invalid
    # # elsif (x != position_x || x != right_one || x != left_one) && (y != position_y || y != up_one || y != down_one)
    # #   return false
    # else
    #   return false
    # end


  def valid_move?(x, y)
    return false if is_obstructed?(x, y)
    if moves_only_one_space?(x, y)
      return true
    end
    return false
  end

  def moves_only_one_space?(x, y)
    return false if position_x == x && position_y == y
    if (position_x - x).abs <= 1 && (position_y - y).abs <= 1
      return true
    end
    return false
  end
end