module Api
  class ProfileController < ApplicationController
    def show
      render json: UserSerializer.new(current_user).as_json
    end
  end
end
