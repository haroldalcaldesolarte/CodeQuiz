class User < ApplicationRecord

  belongs_to :course
  belongs_to :role

  has_many :authored_questions, class_name: "Question", foreign_key: "author_id"
  has_many :revised_questions, class_name: "Question", foreign_key: "revisor_id"
  has_many :game_sessions
  has_many :kahoot_games, foreign_key: "host_id"
  has_many :kahoot_participants, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
      
  validates :role, presence: true
  before_validation :set_default_role, on: :create

  def admin?
    self.role == Role.where(name: "admin").first
  end

  def teacher?
    self.role == Role.where(name: "teacher").first
  end

  def student?
    self.role == Role.where(name: "student").first
  end

  def translated_role
    translations = {
      "student" => "Estudiante",
      "teacher" => "Profesor",
      "admin" => "Administrador"
    }
    translations[role.name] || role.name
  end

  def full_name_with_username
    "#{name} #{surname} (#{username})"
  end

  def superuser?
    self.role == Role.where(name: "admin").first || self.role == Role.where(name: "teacher").first
  end

  private

  def set_default_role
    self.role ||= Role.where(name: "student").first
  end
end
