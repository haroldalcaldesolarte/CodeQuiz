class User < ApplicationRecord

  belongs_to :course
  belongs_to :role

  has_many :authored_questions, class_name: "Question", foreign_key: "author_id"
  has_many :revised_questions, class_name: "Question", foreign_key: "revisor_id"

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
