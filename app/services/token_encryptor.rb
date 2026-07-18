class TokenEncryptor
  def self.encrypt(value)
    encryptor.encrypt_and_sign(value)
  end

  def self.decrypt(value)
    encryptor.decrypt_and_verify(value)
  end

  def self.encryptor
    secret = Rails.application.secret_key_base
    key = ActiveSupport::KeyGenerator.new(secret).generate_key("github-token", 32)
    ActiveSupport::MessageEncryptor.new(key)
  end
end
