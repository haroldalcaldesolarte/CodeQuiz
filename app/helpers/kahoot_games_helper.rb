module KahootGamesHelper

  def get_kahoot_participant(user, kahoot_game)
    user.kahoot_participants.find_by(kahoot_game: kahoot_game)
  end
end