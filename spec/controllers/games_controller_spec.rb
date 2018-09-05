require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe "games#create action" do
    it "should create a new game and the game's 32 pieces in the database" do
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user)
      sign_in user1
      post :create, params: { game: { user_id: user1.id, opponent: user2.id } }
      expect(response).to redirect_to games_path
      game = Game.last
      expect(game.opponent).to eq(user2.id)
      expect(game.pieces.count).to eq(32)
    end
  end
end