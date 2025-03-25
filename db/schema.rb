# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2025_03_25_111508) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.text "answer_text"
    t.boolean "correct"
    t.bigint "question_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "categories_courses", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "course_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id", "course_id"], name: "index_categories_courses_on_category_id_and_course_id", unique: true
    t.index ["category_id"], name: "index_categories_courses_on_category_id"
    t.index ["course_id"], name: "index_categories_courses_on_course_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.integer "year"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "year"], name: "index_courses_on_name_and_year", unique: true
  end

  create_table "game_responses", force: :cascade do |t|
    t.bigint "game_session_id", null: false
    t.bigint "question_id", null: false
    t.boolean "correct"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_session_id"], name: "index_game_responses_on_game_session_id"
    t.index ["question_id"], name: "index_game_responses_on_question_id"
  end

  create_table "game_sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "category_id", null: false
    t.integer "score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "level_id"
    t.integer "status", default: 0, null: false
    t.index ["category_id"], name: "index_game_sessions_on_category_id"
    t.index ["level_id"], name: "index_game_sessions_on_level_id"
    t.index ["user_id"], name: "index_game_sessions_on_user_id"
  end

  create_table "kahoot_games", force: :cascade do |t|
    t.bigint "host_id", null: false
    t.bigint "category_id", null: false
    t.bigint "level_id", null: false
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "current_question_index", default: 0
    t.index ["category_id"], name: "index_kahoot_games_on_category_id"
    t.index ["host_id"], name: "index_kahoot_games_on_host_id"
    t.index ["level_id"], name: "index_kahoot_games_on_level_id"
  end

  create_table "kahoot_participants", force: :cascade do |t|
    t.bigint "kahoot_game_id", null: false
    t.bigint "user_id", null: false
    t.integer "score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["kahoot_game_id"], name: "index_kahoot_participants_on_kahoot_game_id"
    t.index ["user_id"], name: "index_kahoot_participants_on_user_id"
  end

  create_table "kahoot_questions", force: :cascade do |t|
    t.bigint "kahoot_game_id", null: false
    t.bigint "question_id", null: false
    t.integer "order"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "sent_at"
    t.index ["kahoot_game_id"], name: "index_kahoot_questions_on_kahoot_game_id"
    t.index ["question_id"], name: "index_kahoot_questions_on_question_id"
  end

  create_table "kahoot_responses", force: :cascade do |t|
    t.bigint "kahoot_participant_id", null: false
    t.bigint "kahoot_question_id", null: false
    t.datetime "answered_at"
    t.boolean "correct"
    t.integer "score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["kahoot_participant_id", "kahoot_question_id"], name: "index_unique_participant_question", unique: true
    t.index ["kahoot_participant_id"], name: "index_kahoot_responses_on_kahoot_participant_id"
    t.index ["kahoot_question_id"], name: "index_kahoot_responses_on_kahoot_question_id"
  end

  create_table "levels", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_levels_on_name", unique: true
  end

  create_table "questions", force: :cascade do |t|
    t.text "question_text"
    t.bigint "category_id", null: false
    t.bigint "level_id", null: false
    t.bigint "author_id", null: false
    t.bigint "revisor_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0, null: false
    t.index ["author_id"], name: "index_questions_on_author_id"
    t.index ["category_id"], name: "index_questions_on_category_id"
    t.index ["level_id"], name: "index_questions_on_level_id"
    t.index ["revisor_id"], name: "index_questions_on_revisor_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "username"
    t.string "name"
    t.string "surname"
    t.bigint "course_id"
    t.bigint "role_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_users_on_course_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "categories_courses", "categories"
  add_foreign_key "categories_courses", "courses"
  add_foreign_key "game_responses", "game_sessions"
  add_foreign_key "game_responses", "questions"
  add_foreign_key "game_sessions", "categories"
  add_foreign_key "game_sessions", "levels"
  add_foreign_key "game_sessions", "users"
  add_foreign_key "kahoot_games", "categories"
  add_foreign_key "kahoot_games", "levels"
  add_foreign_key "kahoot_games", "users", column: "host_id"
  add_foreign_key "kahoot_participants", "kahoot_games"
  add_foreign_key "kahoot_participants", "users"
  add_foreign_key "kahoot_questions", "kahoot_games"
  add_foreign_key "kahoot_questions", "questions"
  add_foreign_key "kahoot_responses", "kahoot_participants"
  add_foreign_key "kahoot_responses", "kahoot_questions"
  add_foreign_key "questions", "categories"
  add_foreign_key "questions", "levels"
  add_foreign_key "questions", "users", column: "author_id"
  add_foreign_key "questions", "users", column: "revisor_id"
end
