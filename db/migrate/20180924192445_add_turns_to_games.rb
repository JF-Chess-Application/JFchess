class AddTurnsToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :turns, :integer
  end
end
