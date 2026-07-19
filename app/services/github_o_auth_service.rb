require "net/http"
require "uri"
require "json"

class GithubOAuthService
  class Error < StandardError; end

  TOKEN_URL = URI("https://github.com/login/oauth/access_token")

  def exchange_code(code)
    response = Net::HTTP.post(
      TOKEN_URL,
      URI.encode_www_form(
        client_id: ENV.fetch("GITHUB_CLIENT_ID"),
        client_secret: ENV.fetch("GITHUB_CLIENT_SECRET"),
        code: code,
        redirect_uri: ENV["GITHUB_REDIRECT_URI"]
      ),
      "Accept" => "application/json"
    )

    body = JSON.parse(response.body)
    raise Error, body["error_description"] || "GitHub OAuth failed" if body["error"] || body["access_token"].blank?

    body
  rescue KeyError
    raise Error, "Missing GitHub OAuth environment variables"
  end
end
