class CreateCapturedPieces < ActiveRecord::Migration[5.0]
  def change
    create_table :captured_pieces do |t|
      t.integer :game_id
      t.integer :user_id
      t.string :name
      t.integer :move_count
      t.string :color

      t.timestamps
    end
    add_index :captured_pieces, :game_id
    add_index :captured_pieces, :user_id
  end
end
