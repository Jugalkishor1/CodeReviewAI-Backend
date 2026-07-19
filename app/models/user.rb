class User < ApplicationRecord
  has_many :repositories, dependent: :destroy

  validates :github_id, :login, :github_access_token_ciphertext, presence: true

  def github_access_token
    TokenEncryptor.decrypt(github_access_token_ciphertext)
  end

  def github_access_token=(token)
    self.github_access_token_ciphertext = TokenEncryptor.encrypt(token)
  end

  def self.digest_token(token)
    Digest::SHA256.hexdigest(token)
  end
end
