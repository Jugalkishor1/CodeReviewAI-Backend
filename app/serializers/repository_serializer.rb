class RepositorySerializer
  def initialize(repository)
    @repository = repository
  end

  def as_json(*)
    {
      id: repository.id,
      github_id: repository.github_id,
      name: repository.name,
      full_name: repository.full_name,
      owner_login: repository.owner_login,
      private: repository.private,
      html_url: repository.html_url,
      synced_at: repository.synced_at
    }
  end

  private

  attr_reader :repository
end
