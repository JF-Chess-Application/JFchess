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

  # check? CONDITION 1: CHECK FOR THREATENED KINGS
  def threatened_king?
    # if there is any piece whose valid_move? method returns true to a space with a King in it, return true
    if white_king_threatened? || black_king_threatened?
      return true
    else
      return false
    end
  end

  # check? CONDITION 2: THREATENED KING CAN MOVE
  # The threatened king can move into a different space where no pieces are currently able to capture it
  def threatened_king_can_move?(x, y)
    # these methods should check (1) that the king can make a move to a given x, y AND check each piece from the opposing player. If the king can make the move and an opponent's piece ALSO has a valid_move? to that space, the method should return false. 
    # if the king CAN make a valid_move? to the desired x, y AND there is no opponent's piece with a valid_move? to that space, the method should return true
    if white_king_threatened?
      if white_king.valid_move?(x, y)
        king_can_move = false
        black_pieces.each do |piece|
          next if king_can_move
          if piece.valid_move?(x, y)
            king_can_move = false
          else
            king_can_move = true
          end
        end
      end
      return king_can_move
    end

    if black_king_threatened?
      if black_king.valid_move?(x, y)
        king_can_move = false
        white_pieces.each do |piece|
          # next if king_can_move
          if piece.valid_move?(x, y)
            king_can_move = false
            # return king_can_move
          else
            king_can_move = true
          end
        end
        return king_can_move
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

  # check? CONDITION 3: THE PIECE THREATENING THE KING CAN BE CAPTURED
  # The piece threatening the king can be captured
  def threat_is_capturable?
    # if white_king_threatened?
    #   threats.each do |threat|
    #     black_pieces.each do |piece|
    #       if piece.valid_move?(threat.position_x, threat.position_y)
    #         return true
    #       end
    #       return false
    #     end
    #   end
    # end

    if black_king_threatened?
      can_capture_threat = false
      white_pieces.each do |piece|
        threats.each do |threat|
          next if can_capture_threat
          if piece.valid_move?(threat.position_x, threat.position_y)
            can_capture_threat = true
          else
            can_capture_threat = false
          end
        end
      end
      return can_capture_threat
    end
  end

  # check? CONDITION 4: CAN OBSTRUCT THE THREATENING PIECE'S MOVE
  # There is a piece of the same color as the threatened king that can move between the threat and the king without causing another piece to threaten the king
  def threat_is_obstructable?

  end

  # define a boolean method that determines of the game is in a state of check
  def check?
    if threatened_king? && (threatened_king_can_move? || threat_is_capturable? || threat_is_obstructable?)
      return true
    else
      return false
    end
  end
end