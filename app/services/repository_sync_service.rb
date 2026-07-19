class RepositorySyncService
  def initialize(user)
    @user = user
    @client = GithubClient.new(user.github_access_token)
  end

  def call(search: nil)
    client.repositories(search: search).map do |payload|
      user.repositories.find_or_initialize_by(github_id: payload.fetch("id")).tap do |repository|
        repository.assign_attributes(
          name: payload.fetch("name"),
          full_name: payload.fetch("full_name"),
          owner_login: payload.fetch("owner").fetch("login"),
          private: payload.fetch("private"),
          html_url: payload["html_url"],
          synced_at: Time.current
        )
        repository.save!
      end
    end
  end

  private

  attr_reader :user, :client
end
