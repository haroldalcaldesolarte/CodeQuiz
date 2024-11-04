class ChangeRevisorToBeNullableInQuestions < ActiveRecord::Migration[6.1]
  def change
    change_column_null :questions, :revisor_id, true
  end
end
