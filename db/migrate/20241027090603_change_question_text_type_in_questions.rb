class ChangeQuestionTextTypeInQuestions < ActiveRecord::Migration[6.1]
  def change
    change_column :questions, :question_text, :text
  end
end
