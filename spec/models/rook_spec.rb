require 'rails_helper'

RSpec.describe Piece, type: :model do

  before(:each) do 
    @user = User.create(email: 'bob@example.com', password: 'password')
    @opponent = User.create(email: 'opponent@example.com', password: 'password')
    @game = @user.games.create(opponent: @opponent.id)
    @rook = Piece.find_by(name: 'white rook 1')
  end

  it "should move horizontally" do 

    # Check that move is invalid because of obstructions
    expect(@rook.valid_move?(4, 0)).to eq(false)

    # Move rook to square with horizontal clearance
    @rook.update_attributes(position_x: 0, position_y: 4)

    # Check that move is invalid because it is moving to invalid location
    expect(@rook.valid_move?(7, 3)).to eq(false)

    # Check that move is valid
    expect(@rook.valid_move?(7, 4)).to eq(true)
  end

  it "should move vertically" do 

    # Check that move is invalid because of obstructions
    expect(@rook.valid_move?(0, 4)).to eq(false)

    # Remove obstruction
    pawn_1 = Piece.find_by(name: 'white pawn 1')
    pawn_1.update_attributes(position_x: nil, position_y: nil)

    # Check that move is invalid because it is moving to invalid location
    expect(@rook.valid_move?(7, 3)).to eq(false)

    # Check that move is valid
    expect(@rook.valid_move?(0, 4)).to eq(true)
  end
end