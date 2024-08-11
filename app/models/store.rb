# == Schema Information
#
# Table name: stores
#
#  id          :bigint           not null, primary key
#  description :text
#  logo        :string
#  logo_url    :string
#  name        :string
#  slug        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  public_id   :string
#  user_id     :bigint           not null
#
# Indexes
#
#  index_stores_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Store < ApplicationRecord
  include HasPublicId
  include Slugify

  ATTRIBUTES = [:public_id, :id, :slug].freeze

  belongs_to :user
  has_one :payment_api_key, dependent: :destroy
  has_many :integration
  has_many :product
  has_many :invoice
  validates_presence_of :name, :description, :logo_url
  validates :name, uniqueness: true
  validate :is_owner, on: :update
  default_scope { order(created_at: :desc) }
  after_commit :expire_cache

  def as_json(options = {})
    super(options.merge({ except: [:id, :user_id] }))
  end

  def is_owner
    if self.user != user
      errors.add(:base, "You are not authorized to update this record.")
    end
  end

  def expire_cache
    ATTRIBUTES.each do |attribute|
      Rails.cache.delete("store/#{attribute}/#{self.send(attribute)}")
    end
  end
end
