require "net/http"
require "json"

class GroqReviewService
  class Error < StandardError; end

  API_URL = URI("https://api.groq.com/openai/v1/chat/completions")

  def initialize
    @api_key = ENV.fetch("GROQ_API_KEY")
    @model = ENV.fetch("GROQ_MODEL", "llama-3.3-70b-versatile")
  rescue KeyError
    raise Error, "Missing GROQ_API_KEY"
  end

  def call(pull_request:, diff:)
    response = post_request(pull_request, diff)

    text = response.dig("choices", 0, "message", "content")

    raise Error, "Empty response from Groq" if text.blank?

    parse_json(text)
  end

  private

  attr_reader :api_key, :model

  def post_request(pull_request, diff)
    http = Net::HTTP.new(API_URL.host, API_URL.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(API_URL)

    request["Authorization"] = "Bearer #{api_key}"
    request["Content-Type"] = "application/json"

    request.body = JSON.dump(
      model: model,
      messages: [
        {
          role: "system",
          content: "You are an expert senior software engineer reviewing GitHub pull requests."
        },
        {
          role: "user",
          content: prompt(pull_request, diff)
        }
      ],
      temperature: 0.2,
      response_format: { type: "json_object" }
    )

    response = http.request(request)

    body = JSON.parse(response.body)

    unless response.is_a?(Net::HTTPSuccess)
      raise Error, body.dig("error", "message") || "Groq request failed"
    end

    body
  end

  def parse_json(text)
    JSON.parse(text)
  rescue JSON::ParserError
    {
      "summary" => text,
      "score" => 5,
      "strengths" => [],
      "issues" => [],
      "suggestions" => [],
      "file_comments" => []
    }
  end

  def prompt(pull_request, diff)
    <<~PROMPT
      Review this GitHub Pull Request.

      Return ONLY valid JSON.

      {
        "summary": "string",
        "score": 1,
        "strengths": [],
        "issues": [],
        "suggestions": [],
        "file_comments": [
          {
            "file":"path",
            "line":1,
            "severity":"low",
            "comment":"..."
          }
        ]
      }

      Review for:

      - Bugs
      - Security
      - Performance
      - Code Quality
      - Rails Best Practices
      - React Best Practices
      - Missing Tests

      PR Title:
      #{pull_request.title}

      Repository:
      #{pull_request.repository.full_name}

      Branch:
      #{pull_request.branch} -> #{pull_request.base_branch}

      Diff:

      #{diff.first(30000)}
    PROMPT
  end
end
