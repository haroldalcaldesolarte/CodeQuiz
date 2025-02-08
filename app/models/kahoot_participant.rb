class KahootParticipant < ApplicationRecord
  belongs_to :kahoot_game
  belongs_to :user
  has_many :kahoot_responses, dependent: :destroy

  validates :score, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
