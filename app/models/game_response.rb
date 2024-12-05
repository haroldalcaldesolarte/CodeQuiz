class GameResponse < ApplicationRecord
  belongs_to :game_session
  belongs_to :question
end
