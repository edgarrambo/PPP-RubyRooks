class PiecesController < ApplicationController
  before_action :authenticate_user!
  before_action :player_one_can_only_move_white_and_player_two_can_only_move_black, only: [:show, :update]
  before_action :valid_move?, only: [:update]

  def show
    @piece = Piece.find(params[:id])
  end

  def update
    @piece = Piece.find(params[:id])
    @game = Game.find(@piece.game_id)
    x = piece_params[:x_position].to_i
    y = piece_params[:y_position].to_i
    @piece.move_to!(x, y)

    respond_to do |format|
      format.html
      format.js { render 'update.js.erb', game: @game }
      format.json { render json: @piece, status: :ok, file: '/pieces/update' }
    end
  end

  private

  def piece_params
    params.require(:piece).permit(:x_position, :y_position)
  end

  def player_one_can_only_move_white_and_player_two_can_only_move_black
    @piece = Piece.find(params[:id])
    return unless @piece.is_white? && @piece.game.player_one != current_user ||
                  !@piece.is_white? && @piece.game.player_two != current_user

    respond_to do |format|
      format.html { flash.alert = 'That is not your piece!' }
      format.json { render json: @piece, status: 422 }
    end
  end

  def valid_move?
    @piece = Piece.find(params[:id])
    x = piece_params[:x_position].to_i
    y = piece_params[:y_position].to_i
    return if @piece.valid_move?(x, y)

    respond_to do |format|
      format.html { flash.alert = 'Invalid move!' }
      format.json { render json: @piece, status: 422 }
    end
  end
end
