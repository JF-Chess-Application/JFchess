class Game < ApplicationRecord
  belongs_to :user
  has_many :pieces
  scope :available, -> { where(opponent: nil) }


  # define a method to check if a piece is already on a specific space
  def piece_in_space?(x, y)
    pieces.where(position_x: x, position_y: y).any? ? true : false
  end
end
