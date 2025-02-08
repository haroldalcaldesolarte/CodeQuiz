class KahootParticipantsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_kahoot_game, only: [:create]

  def new
  end
  
  def create
    if @kahoot_game.waiting?
      @participant = @kahoot_game.kahoot_participants.build(user: current_user, score: 0)

      if @participant.save
        redirect_to @kahoot_game, notice: "Te has unido a la partida."
      else
        redirect_to @kahoot_game, alert: "No se pudo unir a la partida."
      end
    else
      redirect_to root_path, alert: "No te puedes unir a esta partida."
    end
  end

  private

  def set_kahoot_game
    @kahoot_game = KahootGame.find(params[:kahoot_game_id])
  end

  def kahoot_participant_params
    params.require(:kahoot_participant).permit(:kahoot_game_id)
  end
end
