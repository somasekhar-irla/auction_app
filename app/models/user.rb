class User < ApplicationRecord
  include EncryptPassword
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :name, :password_digest, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEX }

  def login_json
    payload = UserSerializer.new(self).serializable_hash
    payload[:auth_token] = auth_token
    { data: payload }
  end

  protected
   def auth_token
      Utils::Crypt.encrypt("#{id}/#{self.class.name}/#{Time.now.to_i}")
   end
end
