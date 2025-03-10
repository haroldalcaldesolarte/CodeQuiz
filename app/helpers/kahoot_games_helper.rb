module KahootGamesHelper

  def get_kahoot_participant(user, kahoot_game)
    user.kahoot_participants.find_by(kahoot_game: kahoot_game)
  end

  def check_duplicate_answers(user, kahoot_question)
    kahoot_participant = get_kahoot_participant(user, kahoot_question.kahoot_game)
    KahootResponse.exists?(kahoot_participant: kahoot_participant, kahoot_question: kahoot_question)
  end
end