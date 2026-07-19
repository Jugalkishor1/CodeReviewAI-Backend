class CreateReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :reviews do |t|
      t.references :pull_request, null: false, foreign_key: true
      t.text :summary, null: false
      t.integer :score, null: false
      t.jsonb :strengths, null: false, default: []
      t.jsonb :issues, null: false, default: []
      t.jsonb :suggestions, null: false, default: []
      t.jsonb :file_comments, null: false, default: []
      t.jsonb :raw_ai_response, null: false, default: {}

      t.timestamps
    end

    add_index :reviews, :created_at
  end
end
