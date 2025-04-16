class KahootGameChannel < ApplicationCable::Channel
  def subscribed
    @kahoot_game = KahootGame.find(params[:game_id])
    participant = KahootParticipant.find_by(user: current_user, kahoot_game: @kahoot_game)
    host = @kahoot_game.host
    
    stream_for @kahoot_game
    stream_for participant if participant
    stream_for host if current_user == host
    connection.kahoot_game_id = @kahoot_game.id
  end

  def unsubscribed
    @kahoot_game = KahootGame.find(params[:game_id])
    return if @kahoot_game.nil?
  
    # Esperamos 3 segundos a ver si se vuelve a conectar
    Thread.new do
      sleep 3
  
      user = current_user
  
      if !ActionCable.server.connections.any? { |conn| conn.current_user == user } #comprobar reconexion
  
        if @kahoot_game.waiting? || @kahoot_game.in_progress?
          if user == @kahoot_game.host
            @kahoot_game.update(status: :canceled)
            KahootGameChannel.broadcast_to(@kahoot_game, { type: "game_canceled" })
          else
            participant = KahootParticipant.find_by(user: user, kahoot_game: @kahoot_game)
            if participant
              if participant.destroy
                KahootResponse.where(kahoot_participant: participant).delete_all
                if @kahoot_game.waiting?
                  KahootGameChannel.broadcast_to(@kahoot_game, { type: "player_left", user_id: current_user.id})
                elsif @kahoot_game.in_progress?
                  count_participants= @kahoot_game.kahoot_participants.size
                  KahootGameChannel.broadcast_to(@kahoot_game.host, { type: "player_left_to_host", count_participants: count_participants})
                end
              end
            end
          end
        end
      else
        Rails.logger.info "Usuario #{user.id} volvió a conectarse. No se hace nada."
      end
    end
  end  
end