# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create show update_invited_user surrender]

  def index
    @games = Game.all
    if current_user
      @created = Game.where(creating_user_id: current_user.id)
      @joined = Game.where(invited_user_id: current_user.id)
    end
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params.merge(creating_user: current_user))
    if @game.valid?
      @game.populate_game
      redirect_to game_path(@game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @game = Game.find(params[:id])
    @captured_black_pieces = @game.pieces.where(x_position: 8)
    @captured_white_pieces = @game.pieces.where(x_position: 9)
  end

  def update_invited_user
    @game = Game.find(params[:game_id])
    @game.update(invited_user_id: current_user.id)
    if @game.valid?
      @game.randomly_assign_players(current_user)
      redirect_to game_path(@game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def surrender
    @game = Game.find(params[:game_id])
    @game.update(state: 'Surrendered')

    if current_user.id == @game.p1_id
      @game.update(winner_id: @game.p2_id)
    else
      @game.update(winner_id: @game.p1_id)
    end

    redirect_to game_path(@game)
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end

end
