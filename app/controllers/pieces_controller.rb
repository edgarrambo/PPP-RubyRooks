class PiecesController < ApplicationController
  before_action :authenticate_user!

  def update
    update_params

    flash.now[:alert] << 'Invalid move!' unless @piece.valid_move?(@x, @y)
    flash.now[:alert] << 'Not your piece!' unless current_player_controls_piece?(@piece)
    check_response = test_check(@piece, @x, @y)
    @piece.move_to!(@x, @y) if flash.now[:alert].empty?
    flash.now[:alert] << @game.end_turn(check_response, current_user) if check_response
  end

  def castle
    piece = Piece.find(params[:piece_id])
    rook = Piece.find(params[:rook_id])
    piece.castle!(rook)
    redirect_to game_path(piece.game)
  end

  def promotion
    update_params

    return unless %w[Bishop Knight Queen Rook].include?(@promotion)

    white_promotions = { 'Bishop' => 2, 'Knight' => 1, 'Queen' => 3, 'Rook' => 0 }
    black_promotions = { 'Bishop' => 8, 'Knight' => 7, 'Queen' => 9, 'Rook' => 6 }

    @piece.is_white? ? number = white_promotions[@promotion] : number = black_promotions[@promotion]
    @piece.update(type: @promotion, piece_number: number)
  end

  private

  def piece_params
    params.require(:piece).permit(:x_position, :y_position)
  end

  def update_params
    @piece = Piece.find(params[:id])
    @game = Game.find(@piece.game_id)
    @x = params[:x_position].to_i
    @y = params[:y_position].to_i
    @promotion = params[:promotion]
    flash.now[:alert] = []
  end

  def current_player_controls_piece?(piece)
    piece.is_white? && piece.game.player_one == current_user ||
      !piece.is_white? && piece.game.player_two == current_user
  end

  def test_check(piece, x, y)
    return false if piece.can_take?(helpers.get_piece(x, y, piece.game))

    if piece.puts_self_in_check?(x, y)
      flash.now[:alert] << 'You cannot put/leave yourself in Check.'
      return false
    end

    return 'Enemy in Check.' if piece.puts_enemy_in_check?(x, y)
  end

  def can_castle? 
    piece = Piece.find(params[:piece_id])
    rook = Piece.find(params[:rook_id])
    if !piece.can_castle?(rook)
      redirect_to game_path(piece.game), alert: "You can not Castle at this time!"
    end

    if piece.is_white? && piece.game.player_one != current_user || !piece.is_white? && piece.game.player_two != current_user
      redirect_to game_path(piece.game), alert: "That is not your piece!"
    end
  end
end
