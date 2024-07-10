# config/initializers/pagination.rb

module Pagination
  def page(num)
    @page = [num.to_i, 1].max
    apply_pagination
  end

  def per(num)
    @per_page = [num.to_i, 1].max
    apply_pagination
  end

  def per_page
    @per_page || 20
  end

  def total_pages
    (total_count.to_f / per_page).ceil
  end

  def current_page
    @page || 1
  end

  def next_page
    current_page < total_pages ? current_page + 1 : nil
  end

  def prev_page
    current_page > 1 ? current_page - 1 : nil
  end

  def total_count
    @total_count ||= except(:limit, :offset).count
  end

  def pagination_meta
    {
      current_page: current_page,
      next_page: next_page,
      prev_page: prev_page,
      total_pages: total_pages,
      total_count: total_count
    }
  end

  private

  def apply_pagination
    offset_value = (current_page - 1) * per_page
    limit(per_page).offset(offset_value)
  end
end

module ActiveRecord
  class Relation
    prepend Pagination
  end
end