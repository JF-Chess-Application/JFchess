module GamesHelper
  
  def get_winner
    if @game.user_id == current_user.id
      return @game.opponent
    else
      return @game.user_id
    end
  end
end
