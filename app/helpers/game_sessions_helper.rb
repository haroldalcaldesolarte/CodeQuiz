module GameSessionsHelper

  def get_random_answers(question)
    question.answers.shuffle
  end
end
