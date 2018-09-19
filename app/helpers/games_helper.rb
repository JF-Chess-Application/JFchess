module GamesHelper
  def render_piece(position_x, position_y)
    piece = Piece.find_by(position_x: position_x, position_y: position_y)
    if piece
      case
        when piece.name == 'black queen'
          return 9819.chr(Encoding::UTF_8)
        when piece.name == 'white queen'
          return 9813.chr(Encoding::UTF_8)
        when piece.name == 'black king'
          return 9818.chr(Encoding::UTF_8)
        when piece.name == 'white king'
          return 9812.chr(Encoding::UTF_8)
        when piece.name == 'black bishop 1'
          return 9821.chr(Encoding::UTF_8)
        when piece.name == 'black bishop 2'
          return 9821.chr(Encoding::UTF_8)
        when piece.name == 'white bishop 1'
          return 9815.chr(Encoding::UTF_8)
        when piece.name == 'white bishop 2'
          return 9815.chr(Encoding::UTF_8)
        when piece.name == 'black knight 1'
          return 9822.chr(Encoding::UTF_8)
        when piece.name == 'black knight 2'
          return 9822.chr(Encoding::UTF_8)
        when piece.name == 'white knight 1'
          return 9816.chr(Encoding::UTF_8)
        when piece.name == 'white knight 2'
          return 9816.chr(Encoding::UTF_8)
        when piece.name == 'black rook 1'
          return 9820.chr(Encoding::UTF_8)
        when piece.name == 'black rook 2'
          return 9820.chr(Encoding::UTF_8)
        when piece.name == 'white rook 1'
          return 9814.chr(Encoding::UTF_8)
        when piece.name == 'white rook 2'
          return 9814.chr(Encoding::UTF_8)
        when piece.name == 'white pawn 1'
          return 9817.chr(Encoding::UTF_8)
        when piece.name == 'white pawn 2'
          return 9817.chr(Encoding::UTF_8)
        when piece.name == 'white pawn 3'
          return 9817.chr(Encoding::UTF_8) 
        when piece.name == 'white pawn 4'
          return 9817.chr(Encoding::UTF_8)
        when piece.name == 'white pawn 5'
          return 9817.chr(Encoding::UTF_8)
        when piece.name == 'white pawn 6'
          return 9817.chr(Encoding::UTF_8)
        when piece.name == 'white pawn 7'
          return 9817.chr(Encoding::UTF_8)
        when piece.name == 'white pawn 8'
          return 9817.chr(Encoding::UTF_8)
        when piece.name == 'black pawn 1'
          return 9823.chr(Encoding::UTF_8)
        when piece.name == 'black pawn 2'
          return 9823.chr(Encoding::UTF_8)
        when piece.name == 'black pawn 3'
          return 9823.chr(Encoding::UTF_8) 
        when piece.name == 'black pawn 4'
          return 9823.chr(Encoding::UTF_8)
        when piece.name == 'black pawn 5'
          return 9823.chr(Encoding::UTF_8)
        when piece.name == 'black pawn 6'
          return 9823.chr(Encoding::UTF_8)
        when piece.name == 'black pawn 7'
          return 9823.chr(Encoding::UTF_8)
        when piece.name == 'black pawn 8'
          return 9823.chr(Encoding::UTF_8)
      end
    else
      return '_'
    end

  end
end
