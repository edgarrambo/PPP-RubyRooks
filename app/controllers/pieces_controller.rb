class PiecesController < ApplicationController
  before_action :authenticate_user!

  def show
    @piece = Piece.find(params[:id])
  end


  def update
    @piece = Piece.find(params[:id])
    @piece.update_attributes(piece_params)
    redirect_to game_path(@piece.game)
  end

  private

  def piece_params
    params.permit(:x_position, :y_position)
  end
end
