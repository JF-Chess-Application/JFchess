class Knight < Piece
	def valid_move?(string_x, string_y)
		x = string_x.to_i
		y = string_y.to_i
		# check validity based on board position - moves off board are invalid. This logic is built into is_obstructed but we aren't calling that method in this subclass
		if x > 7 || x < 0 || y > 7 || y < 0
			return false
		# l-shapes upward
		elsif y == position_y + 2 && (x == position_x + 1 || x == position_x - 1)
			return true
		# l-shapes to the right
		elsif x == position_x + 2 && (y == position_y + 1 || y == position_y - 1)
			return true
		# l-shapes downward
		elsif y == position_y - 2 && (x == position_x - 1 || x == position_x + 1)
			return true
		# l-shapes to the left
		elsif x == position_y - 2 && (x == position_x + 1 || x == position_x - 1)
			return true
		# all other cases
		else
			return false
		end
	end
end