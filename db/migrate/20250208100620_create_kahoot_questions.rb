class CreateKahootQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :kahoot_questions do |t|
      t.references :kahoot_game, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.integer :order #orden de las preguntas en la partida

      t.timestamps
    end
  end
end
