class Game < ApplicationRecord
  belongs_to :user
  has_many :pieces, dependent: :destroy
  has_many :captured_pieces, dependent: :destroy
  scope :available, -> { where(opponent: nil) }
  after_create :populate_black_pieces!
  after_update :populate_white_pieces!

  def populate_black_pieces!
    # QUEENS - the user who created the game will be black, the opponent will be white
    Queen.create(game_id: id, user_id: user_id, position_x: 3, position_y: 7, color: "black", name: "black queen")
    # KINGS
    King.create(game_id: id, user_id: user_id, position_x: 4, position_y: 7, color: "black", name: "black king")
    # BISHOPS
    # black bishops
    Bishop.create(game_id: id, user_id: user_id, position_x: 2, position_y: 7, color: "black", name: "black bishop 1")
    Bishop.create(game_id: id, user_id: user_id, position_x: 5, position_y: 7, color: "black", name: "black bishop 2")
    # KNIGHTS
    # black knights
    Knight.create(game_id: id, user_id: user_id, position_x: 1, position_y: 7, color: "black", name: "black knight 1")
    Knight.create(game_id: id, user_id: user_id, position_x: 6, position_y: 7, color: "black", name: "black knight 2")
    # ROOKS
    # black rooks
    Rook.create(game_id: id, user_id: user_id, position_x: 0, position_y: 7, color: "black", name: "black rook 1")
    Rook.create(game_id: id, user_id: user_id, position_x: 7, position_y: 7, color: "black", name: "black rook 2")
    # PAWNS
    # populate black pawns
    black_pawn_x = 0
    black_pawn_number = 1
    8.times do
      Pawn.create(game_id: id, user_id: user_id, position_x: black_pawn_x, position_y: 6, color: "black", name: "black pawn #{black_pawn_number}")
      black_pawn_x += 1
      black_pawn_number += 1
    end
  end

  def populate_white_pieces!
    # QUEENS - the user who created the game will be black, the opponent will be white
    Queen.create(game_id: id, user_id: opponent, position_x: 3, position_y: 0, color: "white", name: "white queen")
    # KINGS
    King.create(game_id: id, user_id: opponent, position_x: 4, position_y: 0, color: "white", name: "white king")
    # BISHOPS
    # white bishops
    Bishop.create(game_id: id, user_id: opponent, position_x: 2, position_y: 0, color: "white", name: "white bishop 1")
    Bishop.create(game_id: id, user_id: opponent, position_x: 5, position_y: 0, color: "white", name: "white bishop 2")
    # white knights
    Knight.create(game_id: id, user_id: opponent, position_x: 1, position_y: 0, color: "white", name: "white knight 1")
    Knight.create(game_id: id, user_id: opponent, position_x: 6, position_y: 0, color: "white", name: "white knight 2")
    # white rooks
    Rook.create(game_id: id, user_id: opponent, position_x: 0, position_y: 0, color: "white", name: "white rook 1")
    Rook.create(game_id: id, user_id: opponent, position_x: 7, position_y: 0, color: "white", name: "white rook 2")
    # populate white pawns
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

  # define a boolean method that determines of the game is in a state of check
  def in_check?
    white_king = King.where(game_id: id, color: 'white').inspect
    black_king = King.where(game_id: id, color: 'black').inspect
    puts "white king is #{white_king}"
    puts "black king is #{black_king}"
    # HELPER METHOD: CHECK FOR THREATENED KINGS
    # 1st condition (must be true): There is at least one piece on the board who could "capture" either king
    # if there is any piece whose valid_move? method returns true to a space with a King in it
      # loop through all the pieces in the game whose status is nil
      # pieces.each do |piece|
        # if a black piece has a valid_move?(white_king_x, white_king_y) || # if a white piece has a valid_move(black_king_x, black_king_y)
        # return true
      # end

    # Additional conditions (at least one must be true)
      # HELPER METHOD: THREATENED KING CAN MOVE
      # 2nd condition: The threatened king can move into a different space where no pieces are currently able to capture it
      # OR
      # HELPER METHOD: THE PIECE THREATENING THE KING CAN BE CAPTURED
      # 3rd condition: The piece threatening the king can be captured
      # OR
      # HELPER METHOD: CAN OBSTRUCT THE THREATENING PIECE'S MOVE
      # 4th condition: There is a piece of the same color as the threatened king that can move between the threat and the king
      # return true

      # if threatened_kings? && (threatened_king_can_move? || capture_threat? || obstruct_threat?)
        # return true
      # else
        # return false
  end
end