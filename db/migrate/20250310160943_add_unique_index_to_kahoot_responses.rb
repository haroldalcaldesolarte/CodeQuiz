class AddUniqueIndexToKahootResponses < ActiveRecord::Migration[6.1]
  def change
    add_index :kahoot_responses, [:kahoot_participant_id, :kahoot_question_id], unique: true, name: 'index_unique_participant_question'
  end
end
