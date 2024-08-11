# == Schema Information
#
# Table name: products
#
#  id              :bigint           not null, primary key
#  description     :text
#  gallery_imaages :text             default([]), is an Array
#  image_url       :string
#  name            :string
#  price           :decimal(, )
#  repo_link       :string
#  slug            :string
#  url             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  public_id       :string
#  store_id        :bigint           not null
#
# Indexes
#
#  index_products_on_store_id  (store_id)
#
# Foreign Keys
#
#  fk_rails_...  (store_id => stores.id)
#
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
