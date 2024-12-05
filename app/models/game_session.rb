class GameSession < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :game_responses, dependent: :destroy
end
