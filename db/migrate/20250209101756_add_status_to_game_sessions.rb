class AddStatusToGameSessions < ActiveRecord::Migration[6.1]
  def change
    add_column :game_sessions, :status, :integer, default: 0, null: false
  end
end
