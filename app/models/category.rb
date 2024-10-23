class Category < ApplicationRecord
  has_many :categories_courses
  has_many :courses, through: :categories_courses
  
  validates :name, presence: true, uniqueness: { message: "Esta categoría ya existe" }
end
