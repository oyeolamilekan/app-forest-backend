# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :text
#  first_name      :string
#  last_name       :text
#  password        :text
#  password_digest :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  public_id       :text
#
class User < ApplicationRecord
  include HasPublicId

  has_secure_password

  validates_presence_of :email, :password, :first_name, :last_name
  validates_uniqueness_of :email, message: "This user with email already exists"
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  before_save :lowercase
  has_many :stores, class_name: "store", foreign_key: "user_id"
  after_create :send_user_welcome_mail
  after_update :expire_cache

  def as_json(options = {})
    super(options.merge({ except: [:id, :password, :password_digest], methods: [:token] }))
  end

  def update_password(password)
    self.update!(password: password)
  end

  def lowercase
    self.first_name = first_name.downcase
    self.last_name = last_name.downcase
  end

  def token
    status, payload = Users::EncodeJsonWebToken.call(payload: {user_id: self.id})
    return payload if status == :success
  end

  def send_user_welcome_mail
    UserMailer.welcome_email(self).deliver_later
  end

  def expire_cache
    Rails.cache.delete("user/#{self.id}")
  end
end
