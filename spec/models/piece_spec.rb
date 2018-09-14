require 'rails_helper'

RSpec.describe Piece, type: :model do

  before(:each) do 
    @user = User.create(email: 'bob@example.com', password: 'password')
    @opponent = User.create(email: 'opponent@example.com', password: 'password')
    @game = @user.games.create(opponent: @opponent.id)
    @piece = @user.pieces.first
    @opponents_piece = @opponent.pieces.first
    @other_piece = @user.pieces.last
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

    # Check that piece moved to captured pieces
    expect(@game.captured_pieces.count).to eq(1)
    expect(@game.pieces.count).to eq(31)

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

  end
end