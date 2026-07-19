module Api
  class PullRequestsController < ApplicationController
    def index
      repository = current_user.repositories.find(params[:id])
      pull_requests = PullRequestSyncService.new(current_user, repository).call
      render json: pull_requests.map { |pull_request| PullRequestSerializer.new(pull_request).as_json }
    end

    def show
      pull_request = scoped_pull_requests.find(params[:id])
      render json: PullRequestSerializer.new(pull_request, include_reviews: true).as_json
    end

    private

    def scoped_pull_requests
      PullRequest.joins(:repository).where(repositories: { user_id: current_user.id })
    end
  end
end
