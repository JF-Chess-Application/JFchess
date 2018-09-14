class Piece < ApplicationRecord
  belongs_to :user
  belongs_to :game

  # find the low end of the range of horizontal values to check; self.position + 1 excludes the current square
  def x_begin(x)
    [x, position_x + 1].min
  end

  # find the upper end of the range of horizontal values to check; position_x - 1 excludes the current square
  def x_end(x)
    [x, position_x - 1].max
  end

  # find the low end of the range of vertical values to check; position + 1 excludes the current square
  def y_begin(y)
    [y, position_y + 1].min
  end

  # find the upper end of the range of horizontal values to check; position_y - 1 excludes the current square
  def y_end(y)
    [y, position_y - 1].max
  end

  # set range helper methods
  def x_range(x)
    x_begin(x)..x_end(x)
  end

  def y_range(y)
    y_begin(y)..y_end(y)
  end

  # check if a horizontal move is blocked
  def check_horizontal_obstructions(x, y)
    x_range(x).each do |x|
      if game.piece_in_space?(x, y)
        return true
      end
    end
    return false
  end

  # check if a vertical move is blocked
  def check_vertical_obstructions(x, y)
    y_range(y).each do |y|
      if game.piece_in_space?(x, y)
        return true
      end
    end
    return false
  end

  # moved this call into a separate method for DRY reasons
  def check_temporary_values(x_temp, y_temp)
    game.piece_in_space?(x_temp, y_temp)
  end

  # check if a diagonal move is blocked
  def check_diagonal_obstructions(x, y)
    # if desired move is diagonal up and to the right
    if x > position_x && y > position_y
      x_temp = position_x + 1
      y_temp = position_y + 1
      until x_temp == x && y_temp == y
        if check_temporary_values(x_temp, y_temp)
          return true
        end
        x_temp += 1
        y_temp += 1
      end
      return false
    # if desired move is diagonal up and to the left
    elsif x < position_x && y > position_y
      x_temp = position_x - 1
      y_temp = position_y + 1
      until x_temp == x && y_temp == y
        if check_temporary_values(x_temp, y_temp)
          return true
        end
        x_temp -= 1
        y_temp += 1
      end
      return false
    # if desired move is diagonal down and to the right
    elsif x > position_x && y < position_y
      x_temp = position_x + 1
      y_temp = position_y - 1
      until x_temp == x && y_temp == y
        if check_temporary_values(x_temp, y_temp)
          return true
        end
        x_temp += 1
        y_temp -= 1
      end
      return false
    # if desired move is diagonal down to the left
    elsif x < position_x && y < position_y
      x_temp = position_x - 1
      y_temp = position_y - 1
      until x_temp == x && y_temp == y
        if check_temporary_values(x_temp, y_temp)
          return true
        end
        x_temp -= 1
        y_temp -= 1
      end
      return false
    end
  end

  def is_obstructed?(x, y)
    # show an alert if the move is invalid. Based on this StackOverflow post (https://bit.ly/2MAKSuc), 
    # looks like we may be able to pass this :error to the view through the controller, eventually
    if x > 7 || x < 0 || y > 7 || y < 0
      return [nil, { :error => "That move is not allowed" }]
    # check if desired move is horizontal
    elsif x != position_x && y == position_y
      return check_horizontal_obstructions(x, y)
    # check if desired move is vertical
    elsif x == position_x && y != position_y
      return check_vertical_obstructions(x, y)
    # check if desired move is diagonal
    elsif x != position_x && y != position_y
      return check_diagonal_obstructions(x, y)
    end
  end

  # Remove the piece from the board
  def remove_piece(piece) 
    CapturedPiece.create(game_id:    piece.game_id, 
                         user_id:    piece.user_id,
                         name:       piece.name,
                         move_count: piece.move_count,
                         color:      piece.color)
    piece.destroy
  end

  # Move a piece to the designated location
  def move_to(x, y)

    if game.piece_in_space?(x, y)
      other_piece = Piece.find_by(position_x: x, position_y: y)

      # If piece belongs to opponent, remove it from the board
      if other_piece.user_id != user_id
        remove_piece(other_piece)
      end

      # If piece belongs to player, the move should fail
      if other_piece.user_id == user_id
        return 'Move failed'
      end

    end
    # Move the piece to the designated coordinates
    self.update_attributes(position_x: x, position_y: y)

    # update the move_count
    new_move_count = self.move_count + 1
    self.update_attributes(move_count: new_move_count)
  end
end
