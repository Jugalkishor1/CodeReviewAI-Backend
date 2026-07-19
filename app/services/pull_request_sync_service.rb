class PullRequestSyncService
  def initialize(user, repository)
    @client = GithubClient.new(user.github_access_token)
    @repository = repository
  end

  def call
    client.pull_requests(repository.full_name).map do |payload|
      details = client.pull_request(repository.full_name, payload.fetch("number"))
      repository.pull_requests.find_or_initialize_by(github_id: details.fetch("id")).tap do |pull_request|
        pull_request.assign_attributes(
          number: details.fetch("number"),
          title: details.fetch("title"),
          author: details.fetch("user").fetch("login"),
          branch: details.fetch("head").fetch("ref"),
          base_branch: details.fetch("base").fetch("ref"),
          files_changed: details.fetch("changed_files", 0),
          additions: details.fetch("additions", 0),
          deletions: details.fetch("deletions", 0),
          commits: details.fetch("commits", 0),
          state: details.fetch("state", "open"),
          html_url: details["html_url"],
          synced_at: Time.current
        )
        pull_request.save!
      end
    end
  end

  private

  attr_reader :client, :repository
end
