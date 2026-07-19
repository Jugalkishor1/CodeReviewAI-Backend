module Api
  class RepositoriesController < ApplicationController
    def index
      repositories = SyncRepositoriesJob.perform_now(current_user.id, params[:search])
      render json: repositories.map { |repository| RepositorySerializer.new(repository).as_json }
    end
  end
end
