class PullRequestSerializer
  def initialize(pull_request, include_reviews: false)
    @pull_request = pull_request
    @include_reviews = include_reviews
  end

  def as_json(*)
    data = {
      id: pull_request.id,
      repository_id: pull_request.repository_id,
      repository_full_name: pull_request.repository.full_name,
      number: pull_request.number,
      title: pull_request.title,
      author: pull_request.author,
      branch: pull_request.branch,
      base_branch: pull_request.base_branch,
      files_changed: pull_request.files_changed,
      additions: pull_request.additions,
      deletions: pull_request.deletions,
      commits: pull_request.commits,
      state: pull_request.state,
      html_url: pull_request.html_url,
      synced_at: pull_request.synced_at
    }
    data[:reviews] = pull_request.reviews.order(created_at: :desc).map { |review| ReviewSerializer.new(review).as_json } if include_reviews
    data
  end

  private

  attr_reader :pull_request, :include_reviews
end
