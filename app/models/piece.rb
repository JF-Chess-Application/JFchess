class Piece < ApplicationRecord
  belongs_to :user
  belongs_to :game

  # use the current x_position and y_position to check if spaces are occupied
  def is_obstructed?(position_x, position_y)
    forward_one = position_y + 1
    backward_one = position_y - 1
    right_one = position_x + 1
    left_one = position_x - 1
  # deal with invalid cases first - moves that would put the piece off the board (operating with 0 index for x and y)
    if right_one > 7 || left_one < 0 || forward_one > 7 || backward_one < 0
      return true
  # deal with horizontal movement
    elsif game.piece_in_space?(right_one, position_y) || game.piece_in_space?(left_one, position_y)
      return true
  # deal with vertical movement
    elsif game.piece_in_space?(position_x, forward_one) || game.piece_in_space?(position_x, backward_one)
      return true
  # deal with diagonal movement
    elsif game.piece_in_space?(right_one, forward_one) || game.piece_in_space?(right_one, backward_one) || game.piece_in_space?(left_one, forward_one) || game.piece_in_space?(left_one, backward_one)
      return true
  # if none of those is true, return false
    else
      return false
    end
  end
end
