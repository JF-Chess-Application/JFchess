class Pawn < Piece
	def valid_move?(x, y)
		# if the piece belongs to the white player, moving forward means position_y + 1
		if color == "white"
			# check for invalid moves
			if x > 7 || x < 0 || y > 7 || y < 0
				return false
			# if it's a white pawn's first move, can move two spaces forward to position_y + 2
			elsif y == position_y + 2 && x == position_x && move_count == 0
				if self.is_obstructed?(x, y)
					return false
				else
					return true
				end
			# if it's not the white pawn's first move, it can move forward to position_y + 1
			elsif y == position_y + 1 && x == position_x && move_count > 0
				if self.is_obstructed?(x, y)
					return false
				else
					return true
				end
			# regardless of move_count, the pawn can move forward to position_y + 1 and one space to the left or right, then capture the piece_in_space, if any
			elsif y == position_y + 1 && (x == position_x - 1 || x == position_x + 1)
				if self.is_obstructed?(x, y)
					move_to(x, y)
				else
					return false
				end
			end
		end

		if color == "black"
			# check for invalid moves
			if x > 7 || x < 0 || y > 7 || y < 0
				return false
			# if it's a black pawn's first move, can move two spaces forward to position_y - 2
			elsif y == position_y - 2 && x == position_x && move_count == 0
				if self.is_obstructed?(x, y)
					return false
				else
					return true
				end
			# if it's not the black pawn's first move, it can move forward to position_y - 1
			elsif y == position_y + 1 && x == position_x && move_count > 0
				if self.is_obstructed?(x, y)
					return false
				else
					return true
				end
			# regardless of move_count, the pawn can move forward to position_y - 1 and one space to the left or right, then capture the piece_in_space, if any
			elsif y == position_y - 1 && (x == position_x - 1 || x == position_x + 1)
				if self.is_obstructed?(x, y)
					move_to(x, y)
				else
					return false
				end
			end
		end
	end
end