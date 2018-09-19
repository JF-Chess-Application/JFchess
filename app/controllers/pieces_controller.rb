class PiecesController < ApplicationController
	def edit 
		@piece = Piece.find(params[:id])
	end

	def update
		@piece = Piece.find(params[:id])
		position_x = params[:position_x]
		position_y = params[:position_y]
		@piece.update_attributes(position_x: position_x, position_y: position_y)
		
		@game = Game.find(@piece.game_id)
		redirect_to game_path(@game)
	end
end
