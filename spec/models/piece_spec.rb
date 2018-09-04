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