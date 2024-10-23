class Category < ApplicationRecord
  validates :name, presence: true, uniqueness: { message: "Esta categoría ya existe" }
end
