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
    flash.now[:alert] << 'Invalid move!' unless valid_move?(@piece, x, y)
    flash.now[:alert] << 'Not your piece!' unless current_player_controls_piece?(@piece)
    game_in_check?(@piece, x, y)
    @piece.move_to!(x, y) if flash.now[:alert].empty?
    alert_for_check(@piece)
  end

  private

  def piece_params
    params.require(:piece).permit(:x_position, :y_position)
  end

  def current_player_controls_piece?(piece)
    piece.is_white? && piece.game.player_one == current_user ||
      !piece.is_white? && piece.game.player_two == current_user
  end

  def valid_move?(piece, x, y)
    piece.valid_move?(x, y)
  end

  def game_in_check?(piece, x, y)
    if piece.puts_game_in_check?(x, y)
      if piece.is_white? && piece.game.state == 'White King in Check' ||
         !piece.is_white? && piece.game.state == 'Black King in Check'
        flash.now[:alert] << 'You cannot put yourself in Check.'
        piece.game.update(state: nil)
        return false
      end

      return true
    else
      piece.game.update(state: nil)
      return false
    end
  end

  def alert_for_check(piece)
    if piece.game.state == 'White King in Check'
      flash.now[:alert] << 'White King is in Check.'
    elsif piece.game.state == 'Black King in Check'
      flash.now[:alert] << 'Black King is in Check.'
    end
  end
end
