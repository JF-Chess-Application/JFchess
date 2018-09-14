class PiecesController < ApplicationController
	def show 
		@piece = Piece.find(params[:id])
	end

	def update
		@piece = Piece.find(params[:id])
		@game = Game.find(params[:id])
		if @piece.valid_move?([:x, :y]) && @game(piece_in_space?(x, y) == false)
			@piece.update_attributes(position_x: x, position_y: y)
		end	
		redirect_to game_path(@game)
	end
end
