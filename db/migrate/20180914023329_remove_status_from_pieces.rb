class RemoveStatusFromPieces < ActiveRecord::Migration[5.0]
  def change
    remove_column :pieces, :status
  end
end
