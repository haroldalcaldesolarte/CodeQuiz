class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.string :question_text
      t.references :category, null: false, foreign_key: true
      t.references :level, null: false, foreign_key: true
      t.boolean :approved
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :revisor, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
