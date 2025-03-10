class KahootResponse < ApplicationRecord
  belongs_to :kahoot_participant
  belongs_to :kahoot_question

  validates :answered_at, presence: true, allow_nil: true
  validates :correct, inclusion: { in: [true, false] }

  validates :kahoot_participant_id, uniqueness: { scope: :kahoot_question_id, message: "ya ha respondido esta pregunta" }
  validates :score, presence: true, numericality: { greater_than_or_equal_to: 0 }

end
