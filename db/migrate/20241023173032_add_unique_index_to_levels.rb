class AddUniqueIndexToLevels < ActiveRecord::Migration[6.1]
  def change
    add_index :levels, :name, unique: true
  end
end
