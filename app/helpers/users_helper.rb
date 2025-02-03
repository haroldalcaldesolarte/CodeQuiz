module UsersHelper
  def get_icon_rol(role_name)
    case role_name.downcase
    when 'admin'
      '<i class="fas fa-user-shield" title="Administrador"></i>'.html_safe
    when 'teacher'
      '<i class="fas fa-chalkboard-teacher" title="Profesor"></i>'.html_safe
    when 'student'
      '<i class="fas fa-user-graduate" title="Estudiante"></i>'.html_safe
    else
      '<i class="fas fa-user"></i>'.html_safe
    end
  end
end
