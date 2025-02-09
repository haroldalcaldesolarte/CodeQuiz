class AddLevelToGameSessions < ActiveRecord::Migration[6.1]
  def change
    add_reference :game_sessions, :level, null: false, foreign_key: true
  end
end
