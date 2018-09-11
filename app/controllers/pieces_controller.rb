class PiecesController < ApplicationController
	def show 
		@piece = Piece.find(params[:id])
	end

	def update
		@piece = Piece.find(params[:id])
		if @piece.valid_move?(params[:x_coord, :y_coord]) && @piece.space_empty?
			@piece.update_attributes(params[:id])
		end	
		redirect_to game_path(@game)
	end
end
