class KahootQuestion < ApplicationRecord
  belongs_to :kahoot_game
  belongs_to :question
  has_many :kahoot_responses, dependent: :destroy

  validates :order, presence: true, numericality: { only_integer: true }
end
