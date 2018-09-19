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

  # set methods to define the kings per DRY conventions
  def black_king
    King.find_by(game_id: id, type: 'King', color: 'black')
  end

  def white_king
    King.find_by(game_id: id, type: 'King', color: 'white')
  end
  
  # helper method for threatened_king?
  def white_king_threatened?
    white_king_x = white_king.position_x
    white_king_y = white_king.position_y
    # true if a black piece has a valid_move?(white_king_x, white_king_y)
    self.pieces.each do |piece|
      if piece.color == 'black' && piece.valid_move?(white_king_x, white_king_y)
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
    self.pieces.each do |piece|
      if piece.color == 'white' && piece.valid_move?(black_king_x, black_king_y)
        return true
      end
    end
    return false
  end

  # in_check? CONDITION 1: CHECK FOR THREATENED KINGS
  def threatened_king?
    # if there is any piece whose valid_move? method returns true to a space with a King in it, return true
    if white_king_threatened? || black_king_threatened?
      return true
    else
      return false
    end
  end

  # in_check? CONDITION 2: THREATENED KING CAN MOVE
  # The threatened king can move into a different space where no pieces are currently able to capture it
  def threatened_king_can_move?(x, y)
    # these methods should check (1) that the king can make a move to a given x, y AND check each piece from the opposing player. If the king can make the move and an opponent's piece ALSO has a valid_move? to that space, the method should return false. 
    # if the king CAN make a valid_move? to the desired x, y AND there is no opponent's piece with a valid_move? to that space, the method should return true


    # three arrays - all the places the king can move to, all the places where the opponent's pieces can move, all the places wher eyour pieces (except the king) can move to
      # if the king can move to a spot that's not included in the opponent's pieces
    if white_king_threatened?
      if white_king.valid_move?(x, y)
        king_can_move = false
        self.pieces.each do |piece|
          next if king_can_move
          if piece.color == 'black' && piece.valid_move?(x, y)
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
        puts "the king can move there"
        king_can_move = true
        self.pieces.each do |piece|
          next if king_can_move
          if piece.color == 'white' && piece.valid_move?(x, y)
            king_can_move = false
            puts "the king can't move there"
            return king_can_move
          else
            king_can_move = true
          end
        end
      end
      return king_can_move
    end

    # if black_king_threatened?
    #   if black_king.valid_move?(x, y)
    #     self.pieces.each do |piece|
    #       if piece.color == 'white' && piece.valid_move?(x, y)
    #         puts "there is a piece threatening the king"
    #       end
    #       return true
    #     end
    #   end
    # end
  end


  # new class + new object to store in memory the current state of the game's next move
  # maybe new class called move_manager, instance variables - attr_accessors keep track of threats
  # initialize - board, pieces threatening the king, 
  # can store that instance vars in this class - can then see new ways to move it out of this class
  # functional vs. persisting in memory - OO way is that the threat can store in memory; every time you make a move, you would have an array/variable that you update (pieces_threatening_king) - would always have a list of pieces threatening the king
  # OO - state and behavior - call a functional method somewhere else, result of functional method is stored in memory, so the next time it's called
  # functional - takes an input and gives an output (math), calculator, + is a method, doesn't care about what has happened in the past
  def threat(king)
    # the piece or pieces that have valid_moves to the king's space
    # need to figure out a way to define the threatening piece
    # should also return the piece's color
    # compute all possible moves for the pieces, do any of those overlap for the king's current place

    # if white king, look at black pieces' potential moves
      # do any of the moves have a valid_move?(x, y) where that's the king's position

    # 
  end

  # helper method for threat_is_capturable?
  def is_capturable?
    # if the threatening piece is white, check if any black pieces have a valid_move? to its spot

    # if the threatening piece is black, check if any white pieces have a valid_move? to its spot
  end

  # in_check? CONDITION 3: THE PIECE THREATENING THE KING CAN BE CAPTURED
  # The piece threatening the king can be captured without causing another piece to threaten the king
  def threat_is_capturable?

  end

  # in_check? CONDITION 4: CAN OBSTRUCT THE THREATENING PIECE'S MOVE
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