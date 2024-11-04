module QuestionsHelper
  def is_revisor?
    current_user.admin? || current_user.teacher?
  end
end
