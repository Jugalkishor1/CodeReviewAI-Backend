class GithubClient
  class Error < StandardError; end

  API_ROOT = "https://api.github.com"

  def initialize(token)
    @token = token
  end

  def current_user
    get_json("/user")
  end

  def repositories(search: nil)
    repos = get_json("/user/repos?affiliation=owner,collaborator,organization_member&sort=updated&per_page=100")
    return repos if search.blank?

    query = search.downcase
    repos.select { |repo| repo.fetch("full_name").downcase.include?(query) }
  end

  def pull_requests(full_name)
    get_json("/repos/#{full_name}/pulls?state=open&per_page=100")
  end

  def pull_request(full_name, number)
    get_json("/repos/#{full_name}/pulls/#{number}")
  end

  def pull_request_diff(full_name, number)
    request(:get, "/repos/#{full_name}/pulls/#{number}", accept: "application/vnd.github.v3.diff")
  end

  private

  attr_reader :token

  def get_json(path)
    JSON.parse(request(:get, path))
  end

  def request(method, path, accept: "application/vnd.github+json")
    uri = URI("#{API_ROOT}#{path}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP.const_get(method.to_s.capitalize).new(uri)
    request["Authorization"] = "Bearer #{token}"
    request["Accept"] = accept
    request["X-GitHub-Api-Version"] = "2022-11-28"
    request["User-Agent"] = "ai-pr-review-mvp"

    response = http.request(request)
    raise Error, github_error(response) unless response.is_a?(Net::HTTPSuccess)

    response.body
  end

  def github_error(response)
    body = JSON.parse(response.body)
    body["message"] || "GitHub request failed with #{response.code}"
  rescue JSON::ParserError
    "GitHub request failed with #{response.code}"
  end
end
