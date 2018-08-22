class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.integer :user_id
      t.date :end_date
      t.string :player_one
      t.string :player_two
      t.string :winner

      t.timestamps
    end
    add_index :games, :user_id
  end
end
