class AddStatusToPiece < ActiveRecord::Migration[5.0]
  def change
    add_column :pieces, :status, :string
  end
end
