module Auth
  class GithubController < ApplicationController
    skip_before_action :authenticate_user!

    def create
      code = params.require(:code)
      redirect_uri = params[:redirect_uri].presence
      oauth = GithubOAuthService.new.exchange_code(code, redirect_uri: redirect_uri)
      profile = GithubClient.new(oauth.fetch("access_token")).current_user
      session_token = SecureRandom.urlsafe_base64(48)

      user = User.find_or_initialize_by(github_id: profile.fetch("id").to_s)
      user.assign_attributes(
        login: profile.fetch("login"),
        name: profile["name"],
        avatar_url: profile["avatar_url"],
        github_access_token: oauth.fetch("access_token"),
        session_token_digest: User.digest_token(session_token)
      )
      user.save!

      render json: {
        token: session_token,
        user: UserSerializer.new(user).as_json
      }
    end
  end
end
