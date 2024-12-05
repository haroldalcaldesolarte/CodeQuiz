json.extract! game_session, :id, :user_id, :category_id, :score, :created_at, :updated_at
json.url game_session_url(game_session, format: :json)
