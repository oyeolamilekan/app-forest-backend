class Product < ApplicationRecord
  include Slugify
  include HasPublicId

  ATTRIBUTES = [:public_id, :id, :slug].freeze

  after_commit :expire_cache, on: [:destroy, :update]

  validates_presence_of :name, :description, :price, :repo_link, :image_url
  belongs_to :store
  default_scope { order(created_at: :desc) }

  def as_json(options = {})
    super(options.merge({ except: [:id, :store_id, :repo_link] }))
  end

  def expire_cache
    ATTRIBUTES.each do |attribute|
      Rails.cache.delete("product/#{attribute}/#{self.send(attribute)}")
    end
  end
end
