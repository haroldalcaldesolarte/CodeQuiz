class KahootGameChannel < ApplicationCable::Channel
  def subscribed
    kahoot_game = KahootGame.find(params[:game_id])
    stream_for kahoot_game

    connection.kahoot_game_id = kahoot_game.id
  end

  def unsubscribed
    return unless connection.kahoot_game_id
    return if session.delete(:left_game) # Si salió manualmente, no hacer nada

    kahoot_game = KahootGame.find_by(id: connection.kahoot_game_id)
    return unless kahoot_game

    user = current_user
    participant = kahoot_game.kahoot_participants.find_by(user: user)

    if kahoot_game.host == user
      kahoot_game.kahoot_participants.destroy_all
      kahoot_game.update(status: :canceled)
      KahootGameChannel.broadcast_to(kahoot_game, { type: "game_canceled" })
    else
      participant.destroy
      KahootGameChannel.broadcast_to(kahoot_game, { type: "player_left", user_id: user.id })
    end
  end
end
