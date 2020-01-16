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
    @piece.move_to!(x,y)
      
    respond_to do |format|
      format.html
      format.json {render json: @piece, status: :ok }
    end
  end

  private

  def piece_params
    params.require(:piece).permit(:id, :x_position, :y_position)
  end

  def player_one_can_only_move_white_and_player_two_can_only_move_black
    @piece = Piece.find(params[:id])
    if @piece.is_white? && @piece.game.player_one != current_user || !@piece.is_white? && @piece.game.player_two != current_user
      respond_to do |format|
        format.html {redirect_to game_path(@piece.game), alert: "That is not your piece!"}
        #format.json
      end
    end
  end

  def valid_move?
    @piece = Piece.find(params[:id])
    x = piece_params[:x_position].to_i
    y = piece_params[:y_position].to_i
    if !@piece.valid_move?(x, y)
      respond_to do |format|
        format.html {redirect_to game_path(@piece.game), alert: "Invalid move!"}
        #format.json {render json: @piece.game, messsage: "Invalid move!", status: 422}
      end 
    end
  end

end
