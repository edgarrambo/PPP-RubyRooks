class PiecesController < ApplicationController
  before_action :authenticate_user!

  def show
    @piece = Piece.find(params[:id])
  end

  def update
    @piece = Piece.find(params[:id])
    @game = Game.find(@piece.game_id)
    x = params[:x_position].to_i
    y = params[:y_position].to_i
    flash.now[:alert] = []

    flash.now[:alert] << 'Invalid move!' unless @piece.valid_move?(x, y)
    flash.now[:alert] << 'Not your piece!' unless current_player_controls_piece?(@piece)
    check_response = test_check(@piece, x, y)
    @piece.move_to!(x, y) if flash.now[:alert].empty?
    flash.now[:alert] << @game.end_turn(check_response, current_user) if check_response
  end

  private

  def piece_params
    params.require(:piece).permit(:x_position, :y_position)
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
end
