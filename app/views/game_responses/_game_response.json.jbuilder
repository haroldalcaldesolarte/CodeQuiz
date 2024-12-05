json.extract! game_response, :id, :game_session_id, :question_id, :correct, :created_at, :updated_at
json.url game_response_url(game_response, format: :json)
