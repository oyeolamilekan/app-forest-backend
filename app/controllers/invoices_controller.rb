class InvoicesController < ApplicationController
  before_action :authorize_request
  before_action :validate_params

  def fetch_invoices
    status, result = Invoices::FetchInvoices.new(
      store_id: params[:store_id],
      page: params[:page],
      per_page: params[:per_page]
    ).call
    return api_response(status: true, message: "Invoice successfully fetched", data: result, meta: result.pagination_meta, status_code: :ok) if status == :success
    api_error(message: result, status_code: :server_error)
  end

  def validate_params
    if params[:store_id].blank? && params[:customer_id].blank?
      api_error(message: 'Either store_id or customer_id must be provided', status_code: :bad_request)
    end
  end
end
