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

    selected_questions.each_with_index do |question, index|
      kahoot_questions.create!(question: question, order: index)
    end

    self.current_question_index = 0
    save!
  end

  def self.can_add_questions?(category_id, level_id) #Comprobar si hay suficientes preguntas para empezar la partida
    level = Level.find(level_id)
    category = Category.find(category_id)
    if level && category
      if level.name == "mix"
        Question.where(category_id: category_id, status: :approved).count >= NUMBER_OF_QUESTIONS_PER_KAHOOT
      else
        Question.where(category_id: category_id, level_id: level_id, status: :approved).count >= NUMBER_OF_QUESTIONS_PER_KAHOOT
      end
    end
  end

  def current_question
    kahoot_questions.find_by(order: current_question_index)
  end

  def has_next_question?
    current_question_index < (kahoot_questions.count - 1)
  end

  def next_question
    kahoot_questions.find_by(order: current_question_index+1) if has_next_question?
  end

  def advance_question #actualizar el index cuando se va a enviar la siguiente pregunta
    update(current_question_index: current_question_index + 1) if has_next_question?
  end
end
