class GamesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]

  def index
    @games = Game.all
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params.merge(user_id: current_user.id))
    redirect_to games_path
  end

  def show
    @game = Game.find(params[:id])
  end

  def edit
    @game = Game.find(params[:id])

    if @game.user_id == current_user.id
      return render plain: 'You are already in this game', status: :forbidden
    end
  end

  def update
    @game = Game.find(params[:id])
    @game.update_attributes(game_params.merge(opponent: current_user.id))   
    redirect_to game_path(@game)
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy
    redirect_to games_path
  end

  private

  def game_params
    params.require(:game).permit(:name, :opponent)
  end
end
