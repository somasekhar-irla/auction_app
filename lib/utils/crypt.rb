require 'openssl'

class Utils::Crypt
  def self.encrypt(txt)
    return txt unless txt
    begin
      cipher = OpenSSL::Cipher.new("aes-256-cbc").encrypt
      cipher.key = Digest::MD5.hexdigest ENV.fetch('APP_KEY')
      s = cipher.update(txt) + cipher.final

      s.unpack('H*')[0].upcase
    rescue
      return ""
    end
  end

  def self.decrypt(txt)
    return txt unless txt
    begin
      cipher = OpenSSL::Cipher.new('aes-256-cbc').decrypt
      cipher.key = Digest::MD5.hexdigest ENV.fetch('APP_KEY')
      s = [txt].pack("H*").unpack("C*").pack("c*")

      cipher.update(s) + cipher.final
    rescue
      return ""
    end
  end
end