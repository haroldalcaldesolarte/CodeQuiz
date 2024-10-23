class Course < ApplicationRecord
  validates :name, :year, presence: true
  validates :name, uniqueness: { scope: :year, message: "El curso con este nombre y año ya existe" }
  
end
