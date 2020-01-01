class King < Piece

  def x_move_distance(new_x_position) # Finds the distance moved in the x axis
    x_move_distance = (self.x_position - new_x_position).abs # .abs stops it from being negative
  end

  def y_move_distance(new_y_position) # Finds the distance moved in the y axis
    y_move_distance = (self.y_position - new_y_position).abs # .abs stops it from being negative
  end

  def valid_move?(new_x_position, new_y_position, color=nil)
    invalid = !super
    if invalid
      return false
    else
      x_distance = x_move_distance(new_x_position)
      y_distance = y_move_distance(new_y_position)
      return valid_x_y_move?(x_distance, y_distance)
    end
  end

  def valid_x_y_move?(x_distance, y_distance)
    invalid = !(x_distance == 0 && y_distance == 1) &&    # Vertical move distance is 1
      !(x_distance == 1 && y_distance == 0) &&  # Horizontal move distance is 1
      !(x_distance == 1 && y_distance == 1)     # Diagonal move distance is 1
    invalid ? false : true
  end
  
end
