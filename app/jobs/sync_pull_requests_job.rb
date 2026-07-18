class SyncPullRequestsJob < ApplicationJob
  queue_as :default

  def perform(user_id, repository_id)
    user = User.find(user_id)
    repository = user.repositories.find(repository_id)
    PullRequestSyncService.new(user, repository).call
  end
end
