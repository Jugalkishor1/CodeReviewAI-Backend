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

      review = ReviewGenerationService.new(current_user, pull_request).call
      render json: ReviewSerializer.new(review).as_json, status: :created
    end

    def destroy
      scoped_reviews.find(params[:id]).destroy!
      head :no_content
    end

    private

    def scoped_reviews
      Review.joins(pull_request: :repository).where(repositories: { user_id: current_user.id })
    end
  end
end
