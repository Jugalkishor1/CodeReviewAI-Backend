require "net/http"
require "uri"
require "json"

class GithubOAuthService
  class Error < StandardError; end

  TOKEN_URL = URI("https://github.com/login/oauth/access_token")

  def exchange_code(code, redirect_uri: nil)
    uri = normalize_redirect_uri(redirect_uri.presence || ENV["GITHUB_REDIRECT_URI"])
    raise Error, "Missing GITHUB_REDIRECT_URI" if uri.blank?
    raise Error, "redirect_uri is not allowed: #{uri}" unless allowed_redirect_uri?(uri)

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

  private

  def normalize_redirect_uri(value)
    value.to_s.strip.sub(%r{/\z}, "")
  end

  def allowed_redirect_uri?(uri)
    allowed_redirect_uris.include?(normalize_redirect_uri(uri))
  end

  def allowed_redirect_uris
    [
      ENV["GITHUB_REDIRECT_URI"],
      ENV["FRONTEND_ORIGIN"],
      ENV["FRONTEND_URL"]
    ].compact.flat_map { |value| value.split(",") }.map { |value| normalize_redirect_uri(value) }.reject(&:blank?).uniq
  end
end
