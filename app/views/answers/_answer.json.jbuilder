json.extract! answer, :id, :answer_text, :correct, :question_id, :created_at, :updated_at
json.url answer_url(answer, format: :json)
