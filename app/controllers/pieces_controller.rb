class PiecesController < ApplicationController
  before_action :authenticate_user!
  before_action :player_one_can_only_move_white_and_player_two_can_only_move_black, only: [:show, :update]

  def show
    @piece = Piece.find(params[:id])
  end


  def update
    Piece.find_by_id(params[:id]).update(piece_params)
    redirect_to game_path(@piece.game)
  end

  private

  def piece_params
    params.permit(:x_position, :y_position, :piece_number)
  end

  def player_one_can_only_move_white_and_player_two_can_only_move_black
    @piece = Piece.find(params[:id])
    if @piece.piece_number < 6 && @piece.game.player_one != current_user || @piece.piece_number > 5 && @piece.game.player_two != current_user
      redirect_to game_path(@piece.game), alert: "That is not your piece!"
    end
  end
end