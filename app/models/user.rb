class User < ApplicationRecord
  include HasPublicId

  has_secure_password

  validates_presence_of :email, :password, :first_name, :last_name
  validates_uniqueness_of :email, message: "This user with email already exists"
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  before_save :lowercase
  has_many :stores, class_name: "store", foreign_key: "user_id"

  def as_json(options = {})
    super(options.merge({ except: [:id, :password, :password_digest], methods: [:token] }))
  end

  def lowercase
    self.first_name = first_name.downcase
    self.last_name = last_name.downcase
  end

  def token
    status, payload = Users::EncodeJsonWebToken.call(payload: {user_id: self.id})
    return payload if status == :success
  end
end
