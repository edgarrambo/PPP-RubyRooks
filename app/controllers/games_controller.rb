# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create show update]

  def index
    @games = Game.all
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params.merge(creating_user: current_user))
    if @game.valid?
      redirect_to game_path(@game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @game = Game.find(params[:id])
  end

  def update_invited_user
    @game = Game.find(params[:id])
    @game.update_attributes(invited_user_id: current_user)
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end
end
