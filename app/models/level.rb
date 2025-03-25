class Level < ApplicationRecord
  validates :name, presence: true, uniqueness: { message: "Este nivel ya existe" }

  def get_color
    case name.downcase
    when "easy"
      "success"
    when "medium"
      "warning"
    when "hard"
      "danger"
    when "mix"
      "primary"
    else
      "secondary"
    end
  end

  def self.get_possible_levels
    levels = Level.distinct.pluck(:id, :name).to_h
    levels.reject! { |_, name| name == "mix" }
  end
end
