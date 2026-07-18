Rails.application.routes.draw do
  post "auth/github" => "auth/github#create"
  get "me" => "api/profile#show"

  get "repositories" => "api/repositories#index"
  get "repositories/:id/pull_requests" => "api/pull_requests#index"
  get "pull_requests/:id" => "api/pull_requests#show"
  post "pull_requests/:id/review" => "api/reviews#create"
  get "reviews" => "api/reviews#index"
  get "reviews/:id" => "api/reviews#show"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
