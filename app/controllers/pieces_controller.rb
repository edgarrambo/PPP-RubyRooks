class PiecesController < ApplicationController
  before_action :authenticate_user!

  def show
    @piece = Piece.find(params[:id])
  end

  def update
    @piece = Piece.find(params[:id])
    @game = Game.find(@piece.game_id)
    flash.now[:alert] = []
    flash.now[:alert] << 'Invalid move!' unless valid_move?
    flash.now[:alert] << 'You are in check.' if false
    flash.now[:alert] << 'Not your piece!' unless current_player_controls_piece?
    x = params[:x_position].to_i
    y = params[:y_position].to_i
    @piece.move_to!(x, y) if flash.now[:alert].empty?
  end

  private

  def piece_params
    params.require(:piece).permit(:x_position, :y_position)
  end

  def current_player_controls_piece?
    @piece = Piece.find(params[:id])
    @piece.is_white? && @piece.game.player_one == current_user ||
      !@piece.is_white? && @piece.game.player_two == current_user
  end

  def valid_move?
    @piece = Piece.find(params[:id])
    x = params[:x_position].to_i
    y = params[:y_position].to_i
    @piece.valid_move?(x, y)
  end
end
