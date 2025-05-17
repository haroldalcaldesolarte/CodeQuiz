module KahootGamesHelper

  def get_kahoot_participant(user, kahoot_game)
    user.kahoot_participants.find_by(kahoot_game: kahoot_game)
  end

  def check_duplicate_answers(user, kahoot_question)
    kahoot_participant = get_kahoot_participant(user, kahoot_question.kahoot_game)
    KahootResponse.exists?(kahoot_participant: kahoot_participant, kahoot_question: kahoot_question)
  end

  def get_category(participant)
    participant.kahoot_game.category
  end

  def get_category_by_game(game)
    game.category
  end

  def get_level_by_game(game)
    game.level
  end

  def get_number_of_participants(game)
    game.kahoot_participants&.count || 0
  end
  
  def get_level(participant)
    participant.kahoot_game.level
  end
end