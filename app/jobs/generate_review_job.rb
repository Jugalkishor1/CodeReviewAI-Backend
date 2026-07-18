class GenerateReviewJob < ApplicationJob
  queue_as :default

  def perform(user_id, pull_request_id)
    user = User.find(user_id)
    pull_request = PullRequest
      .joins(:repository)
      .where(repositories: { user_id: user.id })
      .find(pull_request_id)

    ReviewGenerationService.new(user, pull_request).call
  end
end
