# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create show update_invited_user]

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
      populate_game
      redirect_to game_path(@game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @game = Game.find(params[:id])
  end

  def update_invited_user
    @game = Game.find(params[:game_id])
    @game.update(invited_user_id: current_user.id)

    redirect_to game_path(@game)
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end

  def populate_game
    # White Rooks
    @game.pieces.create(x_position: 0, y_position: 0, piece: 0)
    @game.pieces.create(x_position: 0, y_position: 7, piece: 0)
    # White Knights
    @game.pieces.create(x_position: 0, y_position: 1, piece: 1)
    @game.pieces.create(x_position: 0, y_position: 6, piece: 1)
    # White Bishops
    @game.pieces.create(x_position: 0, y_position: 2, piece: 2)
    @game.pieces.create(x_position: 0, y_position: 5, piece: 2)
    # White Queen
    @game.pieces.create(x_position: 0, y_position: 3, piece: 3)
    # White King
    @game.pieces.create(x_position: 0, y_position: 4, piece: 4)
    # White Pawns
    8.times do |y|
      @game.pieces.create(x_position: 1, y_position: y, piece: 5)
    end
    # Black Rooks
    @game.pieces.create(x_position: 7, y_position: 0, piece: 6)
    @game.pieces.create(x_position: 7, y_position: 7, piece: 6)
    # Black Knights
    @game.pieces.create(x_position: 7, y_position: 1, piece: 7)
    @game.pieces.create(x_position: 7, y_position: 6, piece: 7)
    # Black Bishops
    @game.pieces.create(x_position: 7, y_position: 2, piece: 8)
    @game.pieces.create(x_position: 7, y_position: 5, piece: 8)
    # Black Queen
    @game.pieces.create(x_position: 7, y_position: 3, piece: 9)
    # Black King
    @game.pieces.create(x_position: 7, y_position: 4, piece: 10)
    # Black Pawns
    8.times do |y|
      @game.pieces.create(x_position: 6, y_position: y, piece: 11)
    end
  end
end
