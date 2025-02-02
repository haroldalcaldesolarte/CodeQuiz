class ChangeApprovedToStatusInQuestions < ActiveRecord::Migration[6.1]
  def change
    remove_column :questions, :approved, :boolean
    add_column :questions, :status, :integer, default: 0, null: false
  end
end
