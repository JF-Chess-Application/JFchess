class AddColorToPieces < ActiveRecord::Migration[5.0]
  def change
  	add_column :pieces, :color, :string
  end
end
