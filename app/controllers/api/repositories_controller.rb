module Api
  class RepositoriesController < ApplicationController
    def index
      repositories = RepositorySyncService.new(current_user).call(search: params[:search])
      render json: repositories.map { |repository| RepositorySerializer.new(repository).as_json }
    end
  end
end
