module GameSessionsHelper

  def get_random_answers(question)
    question.answers.shuffle
  end

  def get_answers(question)
    question.answers.order(:id)
  end
end
