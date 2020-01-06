class Queen < Piece

    def valid_move?(x, y)
      if is_obstructed?(x, y)
        return false
      end 

      
    end
end
