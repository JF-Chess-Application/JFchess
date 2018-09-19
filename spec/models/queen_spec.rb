require 'rails_helper'

RSpec.describe Queen, type: :model do

  before(:each) do 
    @user1 = User.create(email: 'user1@example.com', password: 'password')
    @user2 = User.create(email: 'user2@example.com', password: 'password')
    @game = @user1.games.create(opponent: @user2.id)
    @queen = Piece.find_by(name: 'white queen')
  end

  it "should move vertically" do 

    # Check that move is invalid because of obstructions
    expect(@queen.valid_move?(3, 4)).to eq(false)

    # Remove obstructions
    pawn_4 = Piece.find_by(name: 'white pawn 4')
    pawn_4.update_attributes(position_x: nil, position_y: nil)

    # Check that horizontal move is valid
    expect(@queen.valid_move?(3, 4)).to eq(true)
  end

  it "should move horizontally" do 

    # Check that move is invalid because of obstructions
    expect(@queen.valid_move?(7, 4)).to eq(false)

    # Move queen to square with horizontal clearance
    @queen.update_attributes(position_x: 1, position_y: 4)

    # Check that horizontal move is valid
    expect(@queen.valid_move?(7, 4)).to eq(true)
  end

  it "should move diagonally" do 

    # Check that move is invalid because of obstructions
    expect(@queen.valid_move?(7, 4)).to eq(false)

    # Remove obstructions
    pawn_5 = Piece.find_by(name: 'white pawn 5')
    pawn_5.update_attributes(position_x: nil, position_y: nil)

    # Check that diagonal move is valid
    expect(@queen.valid_move?(7, 4)).to eq(true)
  end
end
