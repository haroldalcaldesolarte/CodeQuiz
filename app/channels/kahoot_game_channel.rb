class KahootGameChannel < ApplicationCable::Channel
  def subscribed
    kahoot_game = KahootGame.find(params[:game_id])
    stream_for kahoot_game
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
