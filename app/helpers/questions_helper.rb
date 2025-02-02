module QuestionsHelper
  def is_revisor?
    current_user.admin? || current_user.teacher?
  end

  def question_status_icon(question)
    if question.approved?
      '<i class="fas fa-square-check text-success" title="Aprobada"></i>'.html_safe
    elsif question.pending?
      '<i class="fas fa-clock text-secondary" title="Pendiente"></i>'.html_safe
    else
      '<i class="fas fa-square-xmark text-danger" title="Rechazada"></i>'.html_safe
    end
  end

  def get_course_category(category_id)
    course_category = CategoriesCourse.where(category_id: category_id)
    course = Course.where(id: course_category.first.course_id).first
    course.course_display_name
  end

  def get_potencial_reviewer(asker)
    User.where(course_id: asker.course_id).where.not(id: asker.id)
  end
end
