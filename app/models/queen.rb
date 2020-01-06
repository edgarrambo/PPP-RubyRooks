class Queen < Piece

    def valid_move?(x, y)
      if is_obstructed?(x, y)
        return false
      end 

      if y - y_position == 0 # Horizontal Check
        return true
      elsif x - x_position == 0 # Vertical Check
        return true
      elsif (x - x_position).abs == (y - y_position).abs # Diagonal Check
        return true
      else
        return false
      end
    end
end
