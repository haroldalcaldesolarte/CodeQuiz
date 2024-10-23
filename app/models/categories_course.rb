class CategoriesCourse < ApplicationRecord
  belongs_to :category
  belongs_to :course

  validates :category_id, uniqueness: { scope: :course_id, message: "Esta relación ya existe" }
end
