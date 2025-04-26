class CreateKahootParticipants < ActiveRecord::Migration[6.1]
  def change
    create_table :kahoot_participants do |t|
      t.references :kahoot_game, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :score

      t.timestamps
    end
  end
end
