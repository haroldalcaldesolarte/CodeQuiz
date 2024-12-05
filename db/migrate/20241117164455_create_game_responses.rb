class CreateGameResponses < ActiveRecord::Migration[6.1]
  def change
    create_table :game_responses do |t|
      t.references :game_session, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.boolean :correct

      t.timestamps
    end
  end
end
