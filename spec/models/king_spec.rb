require 'rails_helper'

RSpec.describe King, type: :model do

  before(:each) do 
    @user = User.create(email: 'bob@example.com', password: 'password')
    @opponent = User.create(email: 'opponent@example.com', password: 'password')
    @game = @user.games.create(opponent: @opponent.id)
    @king = Piece.find_by(name: 'white king')
    @rook = Piece.find_by(name: 'white rook 1')
  end

  it "should castle" do 

    # Check that castling fails because of obstructions
    expect(@king.castle!(@rook)).to eq('Move failed')

    # Remove obstructions
    piece_1 = Piece.find_by(position_x: 1, position_y: 0)
    piece_2 = Piece.find_by(position_x: 2, position_y: 0)
    piece_3 = Piece.find_by(position_x: 3, position_y: 0)
    piece_1.update_attributes(position_x: nil, position_y: nil)
    piece_2.update_attributes(position_x: nil, position_y: nil)
    piece_3.update_attributes(position_x: nil, position_y: nil)

    # Check that castling succeeds
    @king.castle!(@rook)
    expect(@king.position_x).to eq(2)
    expect(@rook.position_x).to eq(3)

    # Reset postions and check that castle fails when move count of 
    # either piece is greater than 0
    @king.update_attributes(position_x: 4)
    @rook.update_attributes(position_x: 0)
    expect(@king.move_count).to eq(1)
    expect(@rook.move_count).to eq(1)
    expect(@king.castle!(@rook)).to eq('Move failed')
  end


end