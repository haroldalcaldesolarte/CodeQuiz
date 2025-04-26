class CreateKahootResponses < ActiveRecord::Migration[6.1]
  def change
    create_table :kahoot_responses do |t|
      t.references :kahoot_participant, null: false, foreign_key: true
      t.references :kahoot_question, null: false, foreign_key: true
      t.datetime :answered_at
      t.boolean :correct
      t.integer :score

      t.timestamps
    end
  end
end
