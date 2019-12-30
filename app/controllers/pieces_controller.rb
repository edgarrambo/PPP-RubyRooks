class PiecesController < ApplicationController

  def show
    @piece = Piece.find(params[:id])


  end


  def update_position
    @piece = Piece.find(params[:piece_id])
    @piece.update_attributes(x_position: x, y_position: y_position)
    redirect_to game_path(@game)

  end

  private

  def piece_params
    params.require(:piece).permit(:x_position, :y_position)
  end
end
