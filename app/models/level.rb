class Level < ApplicationRecord
  validates :name, presence: true, uniqueness: { message: "Este nivel ya existe" }
end
