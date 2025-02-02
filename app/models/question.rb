class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for :answers, allow_destroy: true  #Permitir la creación de Answer desde el modelo Question
  belongs_to :category
  belongs_to :level
  belongs_to :author, class_name: 'User', foreign_key: "author_id"
  belongs_to :revisor, class_name: 'User', foreign_key: "revisor_id", optional: true
  has_many :game_responses

  enum status: { pending: 0, approved: 1, rejected: 2 }
end
