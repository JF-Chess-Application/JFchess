class King < Piece
  def valid_move?(string_x, string_y)
    x = string_x.to_i
    y = string_y.to_i

    if self.is_obstructed(x, y)
      return false
    end

    # check if it's a valid horizontal move
    if y == position_y && (x == position_x + 1 || x == position_x - 1)
      return true
    # check if it's a valid vertical move
    elsif x == position_x && (y == position_y + 1 || y == position_y - 1)
      return true
    # check if it's a valid diagonal move
    elsif (x == position_x + 1 && y == position_y + 1) || (x == position_x - 1 && y == position_y + 1) || (x == position_x - 1 && y == position_y - 1) || (x == position_x + 1 && y == position_y - 1)
      return true
    # if none of the above, false
    else
      return false
    end
  end

  def can_castle?(rook)

    # Check that neither the king nor rook have moved
    if self.move_count > 0 || rook.move_count > 0
      return false
    end

    # Check that there are no obstructions
    if is_obstructed?(rook.position_x, rook.position_y)
      return false
    end

    return true
  end

  def castle!(rook)

    if can_castle?(rook)
      # Check if rook is king side
      if rook.position_x == 7
        update_attributes(position_x: 6)
        rook.update_attributes(postiion_x: 5)

      # Check if rook is queen side
      elsif rook.position_x == 0
        update_attributes(position_x: 2)
        rook.update_attributes(position_x: 3)
      end

      # Set move count to 1
      self.move_count = 1
      rook.move_count = 1
    else
      return 'Move failed'
    end
    
  end
end