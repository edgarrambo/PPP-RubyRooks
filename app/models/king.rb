class King < Piece

  def valid_move?(new_x, new_y)
    
    if (x_position - new_x).abs == 1 && (y_position - new_y).abs == 0
      return true
    elsif (x_position - new_x).abs == 0 && (y_position - new_y).abs == 1
      return true
    elsif (x_position - new_x).abs == 1 && (y_position - new_y).abs == 1
      return true
    else
      return false
    end    
    
  end  
end
