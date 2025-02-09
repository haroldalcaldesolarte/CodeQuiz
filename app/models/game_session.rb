class GameSession < ApplicationRecord
  belongs_to :user
  belongs_to :category
  belongs_to :level
  has_many :game_responses, dependent: :destroy

  enum status: { in_progress: 0 , finished: 1}
end
