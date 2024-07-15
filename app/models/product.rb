class Product < ApplicationRecord
  include Slugify
  include HasPublicId
  after_destroy :expire_cache

  validates_presence_of :name, :description, :price, :repo_link, :image_url
  belongs_to :store
  default_scope { order(created_at: :desc) }

  def as_json(options = {})
    super(options.merge({ except: [:id, :store_id, :repo_link] }))
  end

  def expire_cache
    Rails.cache.delete("product/#{slug}")
  end
end
