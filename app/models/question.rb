class Question < ApplicationRecord
  belongs_to :category
  belongs_to :level
  belongs_to :author, class_name: 'User', foreign_key: "author_id"
  belongs_to :revisor, class_name: 'User', foreign_key: "revisor_id"
  has_many :answers
end
