json.extract! question, :id, :question_text, :category_id, :level_id, :approved, :author_id, :revisor_id, :created_at, :updated_at
json.url question_url(question, format: :json)
