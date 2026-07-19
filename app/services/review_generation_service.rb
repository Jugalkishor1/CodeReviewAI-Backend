class ReviewGenerationService
  def initialize(user, pull_request)
    @user = user
    @pull_request = pull_request
  end

  def call
    diff = GithubClient.new(user.github_access_token).pull_request_diff(
      pull_request.repository.full_name,
      pull_request.number
    )
    payload = GroqReviewService.new.call(pull_request: pull_request, diff: diff)

    pull_request.reviews.create!(
      summary: payload.fetch("summary", "No summary provided."),
      score: payload.fetch("score", 5).to_i.clamp(1, 10),
      strengths: Array(payload["strengths"]),
      issues: Array(payload["issues"]),
      suggestions: Array(payload["suggestions"]),
      file_comments: Array(payload["file_comments"]),
      raw_ai_response: payload
    )
  end

  private

  attr_reader :user, :pull_request
end
