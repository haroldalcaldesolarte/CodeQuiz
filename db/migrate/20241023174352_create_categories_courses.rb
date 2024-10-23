class CreateCategoriesCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :categories_courses do |t|
      t.references :category, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.index [:category_id, :course_id], unique: true

      t.timestamps
    end
  end
end
