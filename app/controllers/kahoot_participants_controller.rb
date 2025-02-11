class KahootParticipantsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_kahoot_game, only: %i[create]
  before_action :set_participant, only: %i[destroy]

  def new
  end
  
  def create
    if current_user == @kahoot_game.host
     redirect_to @kahoot_game, alert: "Como host de la partida no puedes unirte como participante."
     return
    end

    ids_kahoot_participants = @kahoot_game.kahoot_participants.collect(&:user_id)
    if @kahoot_game.waiting?
      if ids_kahoot_participants.include?(current_user.id)
        redirect_to @kahoot_game, notice: "Ya te has unido a la partida."
      else
        @participant = @kahoot_game.kahoot_participants.build(user: current_user, score: 0)

        if @participant.save
          KahootGameChannel.broadcast_to(@kahoot_game, {type: "new_player", username: current_user.username, user_id: current_user.id})
          redirect_to @kahoot_game, notice: "Te has unido a la partida."
        else
          redirect_to new_kahoot_participant_path, alert: "No se pudo unir a la partida. Vuelva a intentarlo!"
        end
      end
    else
      redirect_to root_path, alert: "No te puedes unir a esta partida."
    end
  end

  def destroy
    kahoot_game = @participant.kahoot_game
    if @participant.destroy
      KahootGameChannel.broadcast_to(kahoot_game, { type: "player_left", user_id: current_user.id })
      redirect_to new_kahoot_participant_path, notice: "Has salido de la partida."
    else
      redirect_to kahoot_game, alert: "No se pudo salir de la partida."
    end
  end

  private

  def set_kahoot_game
    @kahoot_game = KahootGame.find(params[:kahoot_game_id])
  end

  def set_participant
    @participant = KahootParticipant.find_by(id: params[:id], user: current_user)
  
    unless @participant
      redirect_to new_kahoot_participant_path, alert: "No estás en esta partida."
    end
  end

  def kahoot_participant_params
    params.require(:kahoot_participant).permit(:kahoot_game_id)
  end
end
