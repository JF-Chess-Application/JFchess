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
end