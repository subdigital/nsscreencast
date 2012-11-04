class User < ActiveRecord::Base
  authenticates_with_sorcery!

  before_create :generate_auth_token

  def auth_token_expired?
    auth_token_expires_at < Time.now
  end

  def generate_auth_token
    self.auth_token = SecureRandom.hex(20)
    self.auth_token_expires_at = 20.seconds.from_now
  end

  def regenerate_auth_token!
    Rails.logger.info "Regenerating user auth_token"
    generate_auth_token
    save!
  end
end
