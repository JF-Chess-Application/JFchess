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

  # check if a diagnol move is blocked
  def check_diagonal_obstructions(x, y)
    # for each value x in the x_range *combined with* with each value y from the y_range, check
    # if there is a piece in the corresponding space
    x_range(x).each do |x|
      y_range(y).each do |y|
        if game.piece_in_space?(x, y)
          return true
        end
      end
    end
    return false
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
    piece.update_attributes(status: :captured)
  end

  # Move a piece to the designated location
  def move_to(x, y)

    if game.piece_in_space?(x, y)
      other_piece = Piece.find_by(position_x: x, position_y: y)

      # If piece belongs to opponent, remove it from the board
      if other_piece.user_id == game.opponent
        remove_piece(other_piece)
      end

      # If piece belongs to player, the move should fail
      if other_piece.user_id == game.user_id
        return 'Move failed'
      end

    end
    # Move the piece to the designated coordinates
    self.update_attributes(position_x: x, position_y: y)
  end
end
