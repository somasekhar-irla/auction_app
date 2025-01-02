require "active_support/concern"

module EncryptPassword
  extend ActiveSupport::Concern
  included do
    attr_accessor :password
  end

  def valid_password?(password)
    password_digest == ::Utils::Password.encrypt(password)
  end

  def encrypt_password
    if password.present?
      password_digest = ::Utils::Password.encrypt(password)
    else
      errors.add(:password, 'can not be empty')
    end
  end
end
