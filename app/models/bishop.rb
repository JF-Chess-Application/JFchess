class Bishop < Piece
	def valid_move?(x, y)
		diff_x = (position_x - x).abs
		diff_y = (position_y - y).abs
		# if it's a diagonal move and the piece is not obstructed, return true
		if diff_x == diff_y && !self.is_obstructed?(x, y)
			return true
		# if it's a diagonal move and the piece *is* obstructed, return false
		elsif diff_x == diff_y && self.is_obstructed?(x, y)
			return false
		# return false for all other cases
		else
			return false
		end
	end
end