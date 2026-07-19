class CreateRepositories < ActiveRecord::Migration[8.1]
  def change
    create_table :repositories do |t|
      t.references :user, null: false, foreign_key: true
      t.bigint :github_id, null: false
      t.string :name, null: false
      t.string :full_name, null: false
      t.string :owner_login, null: false
      t.boolean :private, null: false, default: false
      t.string :html_url
      t.datetime :synced_at

      t.timestamps
    end

    add_index :repositories, [ :user_id, :github_id ], unique: true
    add_index :repositories, [ :user_id, :full_name ]
  end
end
