module GamesHelper
  def render_piece(position_x, position_y)
    piece = Piece.find_by(position_x: position_x, position_y: position_y)
    # return 9822.chr(Encoding::UTF_8)
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
        when piece.name.include?('white pawn')
          return 9817.chr(Encoding::UTF_8)
        when piece.name.include?('black pawn')
          return 9823.chr(Encoding::UTF_8)
      end
    end
  end
end
