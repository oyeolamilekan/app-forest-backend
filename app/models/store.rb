class Store < ApplicationRecord
  include HasPublicId
  include Slugify

  ATTRIBUTES = [:public_id, :id, :slug].freeze

  belongs_to :user
  has_one :payment_api_key, dependent: :destroy
  has_many :integration
  has_many :product
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
