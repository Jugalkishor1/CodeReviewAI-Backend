class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :github_id, null: false
      t.string :login, null: false
      t.string :name
      t.string :avatar_url
      t.string :github_access_token_ciphertext, null: false
      t.string :session_token_digest

      t.timestamps
    end

    add_index :users, :github_id, unique: true
    add_index :users, :login
    add_index :users, :session_token_digest, unique: true
  end
end
