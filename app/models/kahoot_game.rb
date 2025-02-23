class KahootGame < ApplicationRecord
  belongs_to :host, class_name: 'User', foreign_key: "host_id"
  belongs_to :category
  belongs_to :level
  has_many :kahoot_participants, dependent: :destroy
  has_many :kahoot_questions, dependent: :destroy
  has_many :questions, through: :kahoot_questions

  enum status: { waiting: 0, in_progress: 1, finished: 2, canceled: 3 }

  validates :status, presence: true

  NUMBER_OF_QUESTIONS_PER_KAHOOT = 3

  def add_questions
    return true if questions.any?

    if level.name = "mix"
      selected_questions = Question.where(category: category, status: :approved).order(Arel.sql("RANDOM()")).limit(NUMBER_OF_QUESTIONS_PER_KAHOOT)
    else
      selected_questions = Question.where(category: category, level: level, status: :approved).order(Arel.sql("RANDOM()")).limit(NUMBER_OF_QUESTIONS_PER_KAHOOT)
    end
    return false if selected_questions.empty?
    selected_questions.each_with_index do |question, index|
      kahoot_questions.create!(question: question, order: index)
    end

    self.current_question_index = 0
    save!
  end
end
