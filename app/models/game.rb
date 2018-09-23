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

  # set methods to define the kings and pieces of each color per DRY conventions
  def black_king
    King.find_by(game_id: id, type: 'King', color: 'black')
  end

  def white_king
    King.find_by(game_id: id, type: 'King', color: 'white')
  end

  def black_pieces
    Piece.where(game_id: id, color: 'black')
  end

  def white_pieces
    Piece.where(game_id: id, color: 'white')
  end
  
  # helper method for threatened_king?
  def white_king_threatened?
    white_king_x = white_king.position_x
    white_king_y = white_king.position_y
    # true if a black piece has a valid_move?(white_king_x, white_king_y)
    black_pieces.each do |piece|
      if piece.valid_move?(white_king_x, white_king_y)
        return true
      end
    end
    return false
  end

  # helper method for threatened_king?
  def black_king_threatened?
    black_king_x = black_king.position_x
    black_king_y = black_king.position_y
    # true if a white piece has a valid_move?(black_king_x, black_king_y)
    white_pieces.each do |piece|
      if piece.valid_move?(black_king_x, black_king_y)
        return true
      end
    end
    return false
  end

  # check? condition: CHECK FOR THREATENED KINGS
  def threatened_king?
    # if there is any piece whose valid_move? method returns true to a space with a King in it, return true
    if white_king_threatened? || black_king_threatened?
      return true
    else
      return false
    end
  end

  # define a boolean method that determines of the game is in a state of check
  def check?
    if threatened_king?
      return true
    else
      return false
    end
  end
  
  # checkmate? condition: THREATENED KING CAN'T MOVE
  def threatened_king_can_move?(x, y)
    if white_king_threatened?
      if white_king.valid_move?(x, y)
        black_pieces.each do |piece|
          if piece.valid_move?(x, y)
            return false
          end
        end
      return true
      end
    end

    if black_king_threatened?
      if black_king.valid_move?(x, y)
        white_pieces.each do |piece|
          if piece.valid_move?(x, y)
            return false
          end
        end
      return true
      end
    end
  end

# the piece or pieces that have valid_moves to the king's space
  def threats
    if white_king_threatened?
      black_threats = []
      black_pieces.each do |piece|
        if piece.valid_move?(white_king.position_x, white_king.position_y)
          black_threats.push(piece)
        end
      end
      return black_threats
    end

    if black_king_threatened?
      white_threats = []
      white_pieces.each do |piece|
        if piece.valid_move?(black_king.position_x, black_king.position_y)
          white_threats.push(piece)
        end
      end
      return white_threats
    end
  end

  # checkmate? CONDITION 3: THE PIECE THREATENING THE KING CANNOT BE CAPTURED
  def threat_is_capturable?
    if white_king_threatened?
      white_pieces.each do |piece|
        threats.each do |threat|
          if piece.valid_move?(threat.position_x, threat.position_y)
            return true
          end
        end
      end
      return false
    end

    if black_king_threatened?
      black_pieces.each do |piece|
        threats.each do |threat|
          if piece.valid_move?(threat.position_x, threat.position_y)
            return true
          end
        end
      end
      return false
    end
  end

  # checkmate? CONDITION 4: CANNOT OBSTRUCT THE THREATENING PIECE'S MOVE
  def threat_is_obstructable?

  end
end