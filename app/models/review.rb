class Review < ApplicationRecord
  belongs_to :pull_request

  validates :summary, presence: true
  validates :score, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
end
