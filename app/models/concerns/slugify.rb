module Slugify
  extend ActiveSupport::Concern

  included do
    after_save :slugify_title
  end

  private

  def slugify_title
    self.update_column(:slug, is_a?(Product) ? "#{slugify(self.name)}-#{self.public_id}" : slugify(self.name))
  end

  def slugify(string)
    slug = string.gsub(/[^a-zA-Z0-9]/, '-').downcase
    slug.gsub!(/^-+|-+$/, '')
    return slug
  end
end