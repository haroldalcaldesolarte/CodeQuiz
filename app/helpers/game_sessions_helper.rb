module GameSessionsHelper

  def get_random_answers(question)
    question.answers.order(Arel.sql("RANDOM()"))
  end

  def get_answers(question)
    question.answers
  end
end
