class Role < ApplicationRecord
  validates :name, presence: true, uniqueness: { message: "Este rol ya existe" }
end
