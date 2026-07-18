class SyncRepositoriesJob < ApplicationJob
  queue_as :default

  def perform(user_id, search = nil)
    user = User.find(user_id)
    RepositorySyncService.new(user).call(search: search)
  end
end
