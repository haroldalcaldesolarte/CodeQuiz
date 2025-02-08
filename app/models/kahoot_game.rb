class KahootGame < ApplicationRecord
  belongs_to :host, class_name: 'User', foreign_key: "host_id"
  belongs_to :category
  belongs_to :level
  has_many :kahoot_participants, dependent: :destroy
  has_many :kahoot_questions, dependent: :destroy

  enum status: { waiting: 0, in_progress: 1, finished: 2 }

  validates :status, presence: true
end
