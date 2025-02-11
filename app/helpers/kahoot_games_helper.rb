module KahootGamesHelper
  def has_active_kahoot_games?(user)
    user.kahoot_games.where(status: [:waiting, :in_progress]).exists?
  end

  def get_waiting_kahoot_game_id(user)
    user.kahoot_games.where(status: [:waiting]).first.id
  end

  def get_kahoot_participant(user, kahoot_game)
    user.kahoot_participants.find_by(kahoot_game: kahoot_game)
  end
end