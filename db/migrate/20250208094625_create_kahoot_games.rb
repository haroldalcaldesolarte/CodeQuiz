class CreateKahootGames < ActiveRecord::Migration[6.1]
  def change
    create_table :kahoot_games do |t|
      t.references :host, null: false, foreign_key: { to_table: :users }
      t.references :category, null: false, foreign_key: true
      t.references :level, null: false, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
