require 'digest/sha2'
require 'securerandom'

class Utils::Password
  def self.encrypt(password)
    Digest::SHA2.hexdigest [ENV.fetch('APP_KEY'), password].join(":")
  end

  def self.random_token
    SecureRandom.hex
  end
end