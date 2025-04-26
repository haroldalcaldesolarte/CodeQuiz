class Category < ApplicationRecord
  has_many :categories_courses
  has_many :courses, through: :categories_courses
  
  validates :name, presence: true, uniqueness: { message: "Esta categoría ya existe" }

  def name_with_course
    course_category = CategoriesCourse.where(category_id: self.id)
    course = Course.where(id: course_category.first.course_id).first
    course.course_display_name
    "#{self.name} (#{course.course_display_name})"
  end
end
