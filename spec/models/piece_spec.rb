require 'rails_helper'

RSpec.describe Piece, type: :model do

  before(:each) do 
    @user = User.create(email: 'bob@example.com', password: 'password')
    @opponent = User.create(email: 'opponent@example.com', password: 'password')
    @game = @user.games.create(opponent: @opponent.id)
    @piece = @game.pieces.create(user_id: @user.id, position_x: 1, position_y: 1, status: :onboard)
    @opponents_piece = @game.pieces.create(user_id: @opponent.id, position_x: 5, position_y: 5, status: :onboard)
    @other_piece = @game.pieces.create(user_id: @user.id, position_x: 4, position_y: 4, status: :onboard)
  end

  it "should detect obstructions for vertical movement" do 

    white_rook = @game.pieces.find_by(name: 'white rook 1') 
    black_rook = @game.pieces.find_by(name: 'black rook 1') 

    # Check for obstructions with full board (should return true)
    expect(white_rook.is_obstructed?(black_rook.position_x, black_rook.position_y)).to eq(true)

    # Remove the pawns causing the obstruction
    white_pawn = @game.pieces.find_by(name: 'white pawn 1')
    black_pawn = @game.pieces.find_by(name: 'black pawn 1')
    white_pawn.update_attributes(position_x: nil, position_y: nil)
    black_pawn.update_attributes(position_x: nil, position_y: nil)

    # Check that path is clear moving white rook to black rook
    expect(white_rook.is_obstructed?(black_rook.position_x, black_rook.position_y)).to eq(false)

    # Check that path is clear moving black rook to white rook
    expect(black_rook.is_obstructed?(white_rook.position_x, white_rook.position_y)).to eq(false)
  end

  it "should detect obstructions for horizontal movement" do

    # Move a white rook to a space with horizontal clearance
    white_rook = @game.pieces.find_by(name: 'white rook 1') 
    white_rook.update_attributes(position_x: 0, position_y: 4)

    # Move a black rook to a space directly horizontal to white piece
    black_rook = @game.pieces.find_by(name: 'black rook 1') 
    black_rook.update_attributes(position_x: 7, position_y: 4)

    # Check that path is clear moving white rook to black rook
    expect(white_rook.is_obstructed?(black_rook.position_x, black_rook.position_y)).to eq(false)

    # Check that path is clear moving black rook to white rook
    expect(black_rook.is_obstructed?(white_rook.position_x, white_rook.position_y)).to eq(false)

    # Put a piece between black rook and white rook and check for the obstruction
    white_pawn = @game.pieces.find_by(name: 'white pawn 1')
    white_pawn.update_attributes(position_x: 4, position_y: 4)
    expect(white_rook.is_obstructed?(black_rook.position_x, black_rook.position_y)).to eq(true)
    expect(black_rook.is_obstructed?(white_rook.position_x, white_rook.position_y)).to eq(true)
  end

  it "should detect obstructions for diagonal movement" do 

    white_bishop = @game.pieces.find_by(name: 'white bishop 1')
    black_bishop = @game.pieces.find_by(name: 'black bishop 2')
    white_pawn   = @game.pieces.find_by(name: 'white pawn 4')

    # Relocate black bishop 2 to the right side of the board toward the middle
    black_bishop.update_attributes(position_x: 7, position_y: 5)
    expect(black_bishop.position_x).to eq(7)
    expect(black_bishop.position_y).to eq(5)

    # Check that path between white bishop and black bishop is obstructed by pawn
    expect(white_bishop.is_obstructed?(black_bishop.position_x, white_bishop.position_y)).to eq(true)

    # Remove the white pawn obstructing path 
    white_pawn.update_attributes(position_x: nil, position_y: nil)

    # Check that path from white bishop to black bishop is not obstructed
    expect(white_bishop.is_obstructed?(black_bishop.position_x, black_bishop.position_y)).to eq(false)

    # Check that path from black bishop to white bishop is not obstructed
    expect(black_bishop.is_obstructed?(white_bishop.position_x, white_bishop.position_y)).to eq(false)

    # Move black bishop to left side of the board toward the middle
    black_bishop.update_attributes(position_x: 0, position_y: 5)
    expect(black_bishop.position_x).to eq(0)
    expect(black_bishop.position_y).to eq(5)

    # Select the white bishop on the right side of the board
    white_bishop_2 = @game.pieces.find_by(name: 'white bishop 2')  
    expect(white_bishop_2.position_x).to eq(5)
    expect(white_bishop_2.position_y).to eq(0)

    expect(white_bishop_2.is_obstructed?(black_bishop.position_x, black_bishop.position_y)).to eq(true)

    # Check that the path from white pawn to black pawn is obstructed
    expect(white_bishop_2.is_obstructed?(black_bishop.position_x, black_bishop.position_y)).to eq(true)

    # Remove the pawn blocking the path
    white_pawn = @game.pieces.find_by(name: 'white pawn 5')
    white_pawn.update_attributes(position_x: nil, position_y: nil)

    # Check that the path from white bishop to black bishop is not obstructed
    expect(white_bishop_2.is_obstructed?(black_bishop.position_x, black_bishop.position_y)).to eq(false)

    # Check that the path from black bishop to white bishop is not obstructed
    expect(black_bishop.is_obstructed?(white_bishop_2.position_x, white_bishop_2.position_y)).to eq(false)
  end

  it "move_to should move if square is empty" do 
    move_to_x = 7
    move_to_y = 5
    @piece.move_to(move_to_x, move_to_y)
    @piece.reload

    # Check that piece moved
    expect(@piece.position_x).to eq(move_to_x)
    expect(@piece.position_y).to eq(move_to_y)
  end

  it "move_to should capture opponent's piece" do 
    @piece.move_to(@opponents_piece.position_x, @opponents_piece.position_y)
    @piece.reload

    # Check that piece moved
    expect(@piece.position_x).to eq(@opponents_piece.position_x)
    expect(@piece.position_y).to eq(@opponents_piece.position_y)

    # Check that opponent's piece has been captured
    @opponents_piece.reload
    expect(@opponents_piece.status).to eq("captured")
  end

  it "move_to should fail if other piece belongs to user" do 
    position_x = @piece.position_x
    position_y = @piece.position_y
    result = @piece.move_to(@other_piece.position_x, @other_piece.position_y)
    @piece.reload

    # Check that move failed
    expect(result).to eq('Move failed')   

    # Check that the piece has not moved
    expect(@piece.position_x).to eq(position_x)
    expect(@piece.position_y).to eq(position_y)

    # Check that the other piece is still onboard
    @other_piece.reload
    expect(@other_piece.status).to eq("onboard")
  end
end