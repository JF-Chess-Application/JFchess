class ChangePositionsToIntegers < ActiveRecord::Migration[5.0]
  def change
    change_column :pieces, :position_x, 'integer USING CAST(position_x AS integer)'
    change_column :pieces, :position_y, 'integer USING CAST(position_y AS integer)'
  end
end
