module Api
  class ReviewsController < ApplicationController
    def index
      reviews = Review
        .joins(pull_request: :repository)
        .where(repositories: { user_id: current_user.id })
        .includes(pull_request: :repository)
        .order(created_at: :desc)

      render json: reviews.map { |review| ReviewSerializer.new(review).as_json }
    end

    def show
      render json: ReviewSerializer.new(scoped_reviews.find(params[:id])).as_json
    end

    def create
      pull_request = PullRequest
        .joins(:repository)
        .where(repositories: { user_id: current_user.id })
        .find(params[:id])

      review = GenerateReviewJob.perform_now(current_user.id, pull_request.id)
      render json: ReviewSerializer.new(review).as_json, status: :created
    end

    private

    def scoped_reviews
      Review.joins(pull_request: :repository).where(repositories: { user_id: current_user.id })
    end
  end
end
