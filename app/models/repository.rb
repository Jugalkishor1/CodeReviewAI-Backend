class Repository < ApplicationRecord
  belongs_to :user
  has_many :pull_requests, dependent: :destroy

  validates :github_id, :name, :full_name, :owner_login, presence: true
end
