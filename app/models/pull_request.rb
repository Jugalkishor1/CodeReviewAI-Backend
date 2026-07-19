class PullRequest < ApplicationRecord
  belongs_to :repository
  has_many :reviews, dependent: :destroy

  validates :github_id, :number, :title, :author, :branch, presence: true
end
