class PiecesController < ApplicationController

  def show
    @piece = Piece.find(params[:id])
    

  end


  #def update
    #@piece.update_attributes(piece_params)
    #redirect_to game_path(@game)

  #end
end
