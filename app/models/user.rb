class User < ApplicationRecord
	attr_accessor :remember_token, :reset_token
	before_save { self.email = email.downcase }
	validates :name, presence: true, length: { minimum: 2, maximum: 20 }, 
									 uniqueness: { case_sensitive: false }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 }, 
									  format: { with: VALID_EMAIL_REGEX },
									  uniqueness: { case_sensitive: false }

	has_secure_password
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
	attachment :profile_image

	 # 渡された文字列のハッシュ値を返す
	def User.digest(string)
	  cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
	                                                  BCrypt::Engine.cost
	    BCrypt::Password.create(string, cost: cost)
	end

	# ランダムなトークンを作成
	def User.new_token
		SecureRandom.urlsafe_base64
	end

	# 永続セッションのためにユーザーをデータベースに記憶する
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	# 渡されたトークンがダイジェストと一致したら認証
	def authenticate?(attribute, token)
		digest = send("#{attribute}_digest")
		return false if remember_digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end

	def forget
		update_attribute(:remember_digest, nil)
	end

	def create_reset_digest
		self.reset_token = User.new_token
		update_attribute(:reset_digest, User.digest(reset_token))
		update_attribute(reset_sent_at, Time.zone.now)
	end

	def send_password_reset_email
		UserMailer.password_reset(self).deliver_now
	end

	def password_reset_expired?
       reset_sent_at < 2.hours.ago
    end

end
