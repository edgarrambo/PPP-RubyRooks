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

  def obtain_threat_path(threat)
    y_distance = y_position - threat.y_position
    x_distance = x_position - threat.x_position
    diagonal_types = %w[Queen Bishop]
    lateral_types = %w[Queen Rook]

    if diagonal_types.any? { |piece| piece == threat.type } &&
       (x_position - threat.x_position).abs == (y_position - threat.y_position).abs

      return diagonal_threat_path(x_distance, y_distance)
    elsif lateral_types.any? { |piece| piece == threat.type }
      return horizontal_threat_path(x_distance) if (y_position - threat.y_position).zero?

      return vertical_threat_path(y_distance) if (x_position - threat.x_position).zero?
    end

    []
  end

  def diagonal_threat_path(x_distance, y_distance)
    position_difference = y_distance.abs
    path = []

    if y_distance.positive?
      position_difference.times do |number|
        path << [x_position - number, y_position - number] if x_distance.positive?
        path << [x_position + number, y_position - number] if x_distance.negative?
      end
    elsif y_distance.negative?
      position_difference.times do |number|
        path << [x_position + number, y_position + number] if x_distance.negative?
        path << [x_position - number, y_position + number] if x_distance.positive?
      end
    end

    path.drop(1)
  end

  def vertical_threat_path(y_distance)
    position_difference = y_distance.abs
    path = []

    position_difference.times do |number|
      path << [x_position, y_position - number] if y_distance.positive?
      path << [x_position, y_position + number] if y_distance.negative?
    end

    path.drop(1)
  end

  def horizontal_threat_path(x_distance)
    position_difference = x_distance.abs
    path = []

    position_difference.times do |number|
      path << [x_position - number, y_position] if x_distance.positive?
      path << [x_position + number, y_position] if x_distance.negative?
    end

    path.drop(1)
  end

  def can_escape_check?
    potential_moves = []
    ((x_position - 1)..(x_position + 1)).each do |x|
      ((y_position - 1)..(y_position + 1)).each do |y|
        potential_moves << [x, y]
      end
    end
    potential_moves.select! { |move| move[0] >= 0 && move[1] >= 0 }
    potential_moves.select! { |move| valid_move?(move[0], move[1]) }
    potential_moves.any? { |move| !puts_self_in_check?(move[0], move[1]) }
  end
end
