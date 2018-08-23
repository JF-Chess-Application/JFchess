class CreatePieces < ActiveRecord::Migration[5.0]
  def change
    create_table :pieces do |t|
      t.string :name
      t.integer :game_id
      t.integer :user_id
      t.string :position_x
      t.string :position_y

      t.timestamps
    end
    add_index :pieces, :game_id
    add_index :pieces, :user_id
  end
end
