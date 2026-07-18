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

ActiveRecord::Schema[8.1].define(version: 2026_07_17_000400) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "pull_requests", force: :cascade do |t|
    t.integer "additions", default: 0, null: false
    t.string "author", null: false
    t.string "base_branch"
    t.string "branch", null: false
    t.integer "commits", default: 0, null: false
    t.datetime "created_at", null: false
    t.integer "deletions", default: 0, null: false
    t.integer "files_changed", default: 0, null: false
    t.bigint "github_id", null: false
    t.string "html_url"
    t.integer "number", null: false
    t.bigint "repository_id", null: false
    t.string "state", default: "open", null: false
    t.datetime "synced_at"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["repository_id", "github_id"], name: "index_pull_requests_on_repository_id_and_github_id", unique: true
    t.index ["repository_id", "number"], name: "index_pull_requests_on_repository_id_and_number", unique: true
    t.index ["repository_id"], name: "index_pull_requests_on_repository_id"
  end

  create_table "repositories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "full_name", null: false
    t.bigint "github_id", null: false
    t.string "html_url"
    t.string "name", null: false
    t.string "owner_login", null: false
    t.boolean "private", default: false, null: false
    t.datetime "synced_at"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id", "full_name"], name: "index_repositories_on_user_id_and_full_name"
    t.index ["user_id", "github_id"], name: "index_repositories_on_user_id_and_github_id", unique: true
    t.index ["user_id"], name: "index_repositories_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "file_comments", default: [], null: false
    t.jsonb "issues", default: [], null: false
    t.bigint "pull_request_id", null: false
    t.jsonb "raw_ai_response", default: {}, null: false
    t.integer "score", null: false
    t.jsonb "strengths", default: [], null: false
    t.jsonb "suggestions", default: [], null: false
    t.text "summary", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_reviews_on_created_at"
    t.index ["pull_request_id"], name: "index_reviews_on_pull_request_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.string "github_access_token_ciphertext", null: false
    t.string "github_id", null: false
    t.string "login", null: false
    t.string "name"
    t.string "session_token_digest"
    t.datetime "updated_at", null: false
    t.index ["github_id"], name: "index_users_on_github_id", unique: true
    t.index ["login"], name: "index_users_on_login"
    t.index ["session_token_digest"], name: "index_users_on_session_token_digest", unique: true
  end

  add_foreign_key "pull_requests", "repositories"
  add_foreign_key "repositories", "users"
  add_foreign_key "reviews", "pull_requests"
end
