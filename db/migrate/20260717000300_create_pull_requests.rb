class CreatePullRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :pull_requests do |t|
      t.references :repository, null: false, foreign_key: true
      t.bigint :github_id, null: false
      t.integer :number, null: false
      t.string :title, null: false
      t.string :author, null: false
      t.string :branch, null: false
      t.string :base_branch
      t.integer :files_changed, null: false, default: 0
      t.integer :additions, null: false, default: 0
      t.integer :deletions, null: false, default: 0
      t.integer :commits, null: false, default: 0
      t.string :state, null: false, default: "open"
      t.string :html_url
      t.datetime :synced_at

      t.timestamps
    end

    add_index :pull_requests, [:repository_id, :github_id], unique: true
    add_index :pull_requests, [:repository_id, :number], unique: true
  end
end
