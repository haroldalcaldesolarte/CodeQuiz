class AddCurrentQuestionIndexToKahootGames < ActiveRecord::Migration[6.1]
  def change
    add_column :kahoot_games, :current_question_index, :integer, default: 0
  end
end
