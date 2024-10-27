class Course < ApplicationRecord
  has_many :categories_courses
  has_many :categories, through: :categories_courses
  
  validates :name, :year, presence: true
  validates :name, uniqueness: { scope: :year, message: "El curso con este nombre y año ya existe" }
  
  def course_display_name
    "#{year}º #{name}"
  end

end
