class PiecesController < ApplicationController

  def index
    @game = Game.find(params[:game_id])
    render json: @game.pieces.all
  end

	def edit 
		@piece = Piece.find(params[:id])
	end

	def update
		@piece = Piece.find(params[:id])
		target_x = params[:position_x]
		target_y = params[:position_y]
		if @piece.valid_move?(target_x, target_y)
			@piece.update_attributes(position_x: target_x, position_y: target_y)
    	# update the move_count
    	new_move_count = @piece.move_count + 1
    	@piece.update_attributes(move_count: new_move_count)
		else
			@game = Game.find(@piece.game_id)
			redirect_to game_path(@game), alert: 'Invalid move. Please try another move.'
			return
		end
	end
end
