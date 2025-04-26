class AddSentAtToKahootQuestions < ActiveRecord::Migration[6.1]
  def change
    add_column :kahoot_questions, :sent_at, :datetime
  end
end
