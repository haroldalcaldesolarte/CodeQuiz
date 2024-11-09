module QuestionsHelper
  def is_revisor?
    current_user.admin? || current_user.teacher?
  end

  def question_status_icon(question)
    if question.approved
      '<i class="fas fa-square-check text-success" title="Aprobada"></i>'.html_safe
    elsif question.approved == false
      '<i class="fas fa-square-xmark text-danger" title="Rechazada"></i>'.html_safe
    else
      '<i class="fas fa-clock text-secondary" title="Pendiente"></i>'.html_safe
    end
  end
end
