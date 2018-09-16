class Game < ApplicationRecord
  belongs_to :user
  has_many :pieces, dependent: :destroy
  has_many :captured_pieces, dependent: :destroy
  scope :available, -> { where(opponent: nil) }
  after_create :populate_black_pieces!
  after_update :populate_white_pieces!

  # upon game creation, populate the black pieces for the user who created the game
  def populate_black_pieces!
    Queen.create(game_id: id, user_id: user_id, position_x: 3, position_y: 7, color: "black", name: "black queen")
    King.create(game_id: id, user_id: user_id, position_x: 4, position_y: 7, color: "black", name: "black king")
    Bishop.create(game_id: id, user_id: user_id, position_x: 2, position_y: 7, color: "black", name: "black bishop 1")
    Bishop.create(game_id: id, user_id: user_id, position_x: 5, position_y: 7, color: "black", name: "black bishop 2")
    Knight.create(game_id: id, user_id: user_id, position_x: 1, position_y: 7, color: "black", name: "black knight 1")
    Knight.create(game_id: id, user_id: user_id, position_x: 6, position_y: 7, color: "black", name: "black knight 2")
    Rook.create(game_id: id, user_id: user_id, position_x: 0, position_y: 7, color: "black", name: "black rook 1")
    Rook.create(game_id: id, user_id: user_id, position_x: 7, position_y: 7, color: "black", name: "black rook 2")
    black_pawn_x = 0
    black_pawn_number = 1
    8.times do
      Pawn.create(game_id: id, user_id: user_id, position_x: black_pawn_x, position_y: 6, color: "black", name: "black pawn #{black_pawn_number}")
      black_pawn_x += 1
      black_pawn_number += 1
    end
  end

  # upon game update, populate the white pieces for the opponent user who joined the game
  def populate_white_pieces!
    Queen.create(game_id: id, user_id: opponent, position_x: 3, position_y: 0, color: "white", name: "white queen")
    King.create(game_id: id, user_id: opponent, position_x: 4, position_y: 0, color: "white", name: "white king")
    Bishop.create(game_id: id, user_id: opponent, position_x: 2, position_y: 0, color: "white", name: "white bishop 1")
    Bishop.create(game_id: id, user_id: opponent, position_x: 5, position_y: 0, color: "white", name: "white bishop 2")
    Knight.create(game_id: id, user_id: opponent, position_x: 1, position_y: 0, color: "white", name: "white knight 1")
    Knight.create(game_id: id, user_id: opponent, position_x: 6, position_y: 0, color: "white", name: "white knight 2")
    Rook.create(game_id: id, user_id: opponent, position_x: 0, position_y: 0, color: "white", name: "white rook 1")
    Rook.create(game_id: id, user_id: opponent, position_x: 7, position_y: 0, color: "white", name: "white rook 2")
    white_pawn_x = 0
    white_pawn_number = 1
    8.times do
      Pawn.create(game_id: id, user_id: opponent, position_x: white_pawn_x, position_y: 1, color: "white", name: "white pawn #{white_pawn_number}")
      white_pawn_x += 1
      white_pawn_number += 1
    end
  end

  # define a method to check if a piece is already on a specific space
  def piece_in_space?(x, y)
    pieces.where(position_x: x, position_y: y).any? ? true : false
  end

  # helper method for threatened_king?
  def white_king_threatened?
    white_king = King.find_by(game_id: id, type: 'King', color: 'white')
    white_king_x = white_king.position_x
    white_king_y = white_king.position_y

    # true if a black piece has a valid_move?(white_king_x, white_king_y)
    pieces.each do |piece|
      if piece.color == 'black' && piece.valid_move?(white_king_x, white_king_y)
        return true
      end
    end
    return false
  end

  # helper method for threatened_king?
  def black_king_threatened?
    black_king = King.find_by(game_id: id, type: 'King', color: 'black')
    black_king_x = black_king.position_x
    black_king_y = black_king.position_y

    # true if a white piece has a valid_move?(black_king_x, black_king_y)
    pieces.each do |piece|
      if piece.color == 'white' && piece.valid_move?(black_king_x, black_king_y)
        return true
      end
    end
    return false
  end

  # HELPER METHOD: CHECK FOR THREATENED KINGS
  # this is the first necessary condition for a game to be in check
  def threatened_king?
    # if there is any piece whose valid_move? method returns true to a space with a King in it, return true
    if white_king_threatened? || black_king_threatened?
      return true
    else
      return false
    end
  end

  # HELPER METHOD: THREATENED KING CAN MOVE
  # 2nd condition: The threatened king can move into a different space where no pieces are currently able to capture it
  def threatened_king_can_move?
    # if white_king_threatened?
      # if the white king has a valid move AND none of the black pieces have a valid_move to x, y
        # return true
      # else
        # return false
      # end
    # end

    # if black_king_threatened?
      # if the black king has a valid move AND none of the white pieces have a valid_move to x, y
        # return true
      # else
        # return false
      # end
    # end
  end

  def is_capturable?
    # need to figure out a way to define the threatening piece 
    # if the threatening piece is white, check if any black pieces have a valid_move? to its spot

    # if the threatening piece is black, check if any white pieces have a valid_move? to its spot
  end

  # HELPER METHOD: THE PIECE THREATENING THE KING CAN BE CAPTURED
  # 3rd condition: The piece threatening the king can be captured without causing another piece to threaten the king
  def threat_is_capturable?

  end

  # HELPER METHOD: CAN OBSTRUCT THE THREATENING PIECE'S MOVE
  # 4th condition: There is a piece of the same color as the threatened king that can move between the threat and the king without causing another piece to threaten the king
    # return true
  def threat_is_obstructable?

  end

  # define a boolean method that determines of the game is in a state of check
  def in_check?
    if threatened_king? && (threatened_king_can_move? || threat_is_capturable? || threat_is_obstructable?)
      return true
    else
      return false
    end
  end
end