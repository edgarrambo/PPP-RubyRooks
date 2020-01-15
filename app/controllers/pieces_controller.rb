class PiecesController < ApplicationController
  before_action :authenticate_user!
  before_action :player_one_can_only_move_white_and_player_two_can_only_move_black, only: [:show, :update]
  before_action :valid_move?, only: [:update]

  def show
    @piece = Piece.find(params[:id])
  end


  def update
   
    @piece = Piece.find(params[:id])
    x = piece_params[:x_position].to_i
    y = piece_params[:y_position].to_i
  if @piece.move_to!(x, y)
    @piece.update(piece_params)
    end
    respond_to do |format|
      format.html
      format.json { render json: @piece, status: :ok }
    end
  end

  private

  def piece_params
    params.permit(:x_position, :y_position)
  end

 def player_one_can_only_move_white_and_player_two_can_only_move_black
  @piece = Piece.find(params[:id])
  if @piece.is_white? && @piece.game.player_one != current_user || !@piece.is_white? && @piece.game.player_two != current_user
    redirect_to game_path(@piece.game), alert: "That is not your piece!"
  end
end

def valid_move?

  @piece = Piece.find(params[:id])
    
   x = piece_params[:x_position].to_i
   y = piece_params[:y_position].to_i
   if !@piece.valid_move?(x, y)
     redirect_to game_path(@piece.game), alert: "This is not a valid move!"
   end
 end
end
