class ReviewSerializer
  def initialize(review)
    @review = review
  end

  def as_json(*)
    {
      id: review.id,
      pull_request_id: review.pull_request_id,
      repository_id: review.pull_request.repository_id,
      pull_request_title: review.pull_request.title,
      repository_full_name: review.pull_request.repository.full_name,
      summary: review.summary,
      score: review.score,
      strengths: review.strengths,
      issues: review.issues,
      suggestions: review.suggestions,
      file_comments: review.file_comments,
      raw_ai_response: review.raw_ai_response,
      created_at: review.created_at
    }
  end

  private

  attr_reader :review
end
