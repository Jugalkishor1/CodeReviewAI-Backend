require "net/http"
require "uri"
require "json"

class GithubOAuthService
  class Error < StandardError; end

  TOKEN_URL = URI("https://github.com/login/oauth/access_token")

  def exchange_code(code, redirect_uri: nil)
    uri = (redirect_uri.presence || ENV["GITHUB_REDIRECT_URI"]).to_s.strip.sub(%r{/\z}, "")
    raise Error, "Missing GITHUB_REDIRECT_URI" if uri.blank?

    response = Net::HTTP.post(
      TOKEN_URL,
      URI.encode_www_form(
        client_id: ENV.fetch("GITHUB_CLIENT_ID"),
        client_secret: ENV.fetch("GITHUB_CLIENT_SECRET"),
        code: code,
        redirect_uri: uri
      ),
      "Accept" => "application/json"
    )

    body = JSON.parse(response.body)
    raise Error, body["error_description"] || body["error"] || "GitHub OAuth failed" if body["error"] || body["access_token"].blank?

    body
  rescue KeyError
    raise Error, "Missing GitHub OAuth environment variables"
  end
end
