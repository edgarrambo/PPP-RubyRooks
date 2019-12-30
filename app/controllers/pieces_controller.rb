class PiecesController < ApplicationController
  before_action :authenticate_user!
  #before_action :require_authorized_to_move_piece
  
  def show
    @piece = Piece.find(params[:id])
  end

  def update_position
    @piece = Piece.find(params[:piece_id])
    @piece.update_attributes(piece_params)
    redirect_to game_path(@piece.game)

  end

  private

  def piece_params
    params.permit(:x_position, :y_position)
  end

  #def require_authorized_to_move_piece
    #if current_user != creating_user || current_user != invited_user
        #render plain: 'Game in progress', status: :Unauthorized
    #end
  #end

end
