class UserSerializer
  def initialize(user)
    @user = user
  end

  def as_json(*)
    {
      id: user.id,
      login: user.login,
      name: user.name,
      avatar_url: user.avatar_url
    }
  end

  private

  attr_reader :user
end
