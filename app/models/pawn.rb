class Pawn < Piece
	def valid_move?(string_x, string_y)
		x = string_x.to_i
		y = string_y.to_i
		# if the piece belongs to the white player, moving forward means adding to position_y
		if color == "white"
			# if it's a white pawn's first move, it is valid for an unbstructed white pawn to move two spaces forward to position_y + 2
			if y == position_y + 2 && x == position_x && move_count == 0
				if self.is_obstructed?(x, y)
					return false
				else
					return true
				end
			# regardless of move_count, it is valid for an unobstructed black pawn to move forward to position_y + 1
			elsif y == position_y + 1 && x == position_x && move_count >= 0
				if self.is_obstructed?(x, y)
					return false
				else
					return true
				end
			# regardless of move_count, it is valid for a white pawn to move forward to position_y + 1 and one space to the left or right, then capture the piece_in_space (self.is_obstructed?(x, y) must == true)
			elsif y == position_y + 1 && (x == position_x - 1 || x == position_x + 1)
				if self.is_obstructed?(x, y)
					move_to(x, y)
				else
					return false
				end
			else
				return false
			end
		end
		# if the piece belongs to the black player, moving forward means subtracting from position_y
		if color == "black"
			# if it's a black pawn's first move, it is valid for an unbstructed black pawn to move two spaces forward to position_y - 2
			if y == position_y - 2 && x == position_x && move_count == 0
				if self.is_obstructed?(x, y)
					return false
				else
					return true
				end
			# regardless of move_count, it is valid for an unobstructed black pawn to move forward to position_y - 1
			elsif y == position_y - 1 && x == position_x && move_count >= 0
				if self.is_obstructed?(x, y)
					return false
				else
					return true
				end
			# regardless of move_count, it is valid for a black pawn can move forward to position_y - 1 and one space to the left or right to capture the piece_in_space (self.is_obstructed?(x, y) must == true)
			elsif y == position_y - 1 && (x == position_x - 1 || x == position_x + 1)
				if self.is_obstructed?(x, y)
					move_to(x, y)
				else
					return false
				end
			else
				return false
			end
		end
	end
end