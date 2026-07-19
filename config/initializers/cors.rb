# Be sure to restart your server when you modify this file.

# Prefer FRONTEND_ORIGIN (documented). FRONTEND_URL is accepted as an alias.
# Comma-separated list supported for local + production, e.g.
# http://localhost:5173,https://code-review-ai-frontend-six.vercel.app
module CorsOrigins
  module_function

  def list
    raw = ENV["FRONTEND_ORIGIN"].presence || ENV["FRONTEND_URL"].presence || "http://localhost:5173"
    origins = raw.split(",").map(&:strip).reject(&:blank?).uniq
    raise "FRONTEND_ORIGIN/FRONTEND_URL produced an empty CORS allowlist" if origins.empty?

    origins
  end
end

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins(*CorsOrigins.list)

    resource "*",
      headers: :any,
      methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
      expose: [ "Authorization" ],
      max_age: 600
  end
end
