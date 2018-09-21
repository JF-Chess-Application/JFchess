class PiecesController < ApplicationController
	def edit 
		@piece = Piece.find(params[:id])
	end

	def update
		@piece = Piece.find(params[:id])
		position_x = params[:position_x]
		position_y = params[:position_y]

		if !current_user_turn 
			render text: 'Please wait your turn',
			status: :unauthorized
		else 
			@piece.update_attributes(position_x: position_x, position_y: position_y)
			
			@game = Game.find(@piece.game_id)
			redirect_to game_path(game)
		end
	end

	private 

	def current_user_turn?
		@game.turn == current_user.id
	end
end
