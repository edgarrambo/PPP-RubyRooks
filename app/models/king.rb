class King < Piece
  def valid_move?(x, y)
    return false if players_own_piece_is_there?(x, y)

    x_distance = (x - x_position).abs
    y_distance = (y - y_position).abs

    if x_distance == 1 && y_distance == 0
      return true
    elsif x_distance == 0 && y_distance == 1
      return true
    elsif x_distance == 1 && y_distance == 1
      return true
    else
      return false
    end
  end

  def detect_threats
    enemies = get_enemies(self)
    threats = enemies.select{|enemy| enemy.can_take?(self)}
  end

  def can_escape_check?
    potential_moves = []
    ((x_position - 1)..(x_position + 1)).each do |x|
      ((y_position - 1)..(y_position + 1)).each do |y|
        potential_moves << [x,y]
      end
    end
    potential_moves.select! {|move| move[0] >= 0 && move[1] >= 0 }
    potential_moves.select! {|move| valid_move?(move[0], move[1])}
    potential_moves.any? { |move| !puts_self_in_check?(move[0],move[1])}
  end

end