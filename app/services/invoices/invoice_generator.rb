require 'prawn'
require 'prawn/table'
require 'open-uri'

module Invoices
  class InvoiceGenerator < ApplicationService
    include ActiveSupport::NumberHelper

    def initialize(invoice:)
      @invoice = invoice
    end

    def call
      generate_pdf
    end

    private

    def generate_pdf
      Prawn::Document.new do |pdf|
        add_header(pdf)
        add_invoice_details(pdf)
        add_client_details(pdf)
        add_product_details(pdf)
        add_total(pdf)
        add_payment_status(pdf)
        add_footer(pdf)
      end
    end

    def add_header(pdf)
      # Add company logo
      pdf.image URI.open(@invoice.store.logo_url), width: 50, height: 50
      pdf.move_down 20

      pdf.text @invoice.store.name, size: 20, style: :bold
      pdf.text @invoice.store.description
      
      pdf.move_down 20
    end

    def add_invoice_details(pdf)
      pdf.text "INVOICE", size: 22, style: :bold
      pdf.text "Invoice Id: #{@invoice.public_id}"
      pdf.text "Date: #{@invoice.created_at.strftime('%B %d, %Y')}"
      
      pdf.move_down 20
    end

    def add_client_details(pdf)
      pdf.text "Bill To:", style: :bold
      pdf.text @invoice.customer.name
      pdf.text @invoice.customer.email
      
      pdf.move_down 20
    end

    def add_product_details(pdf)
      pdf.text "Product/Service Details:", style: :bold
      pdf.text @invoice.description
      
      pdf.move_down 20

      data = [
        ["Description", "Price"],
        [@invoice.description, number_to_delimited(@invoice.total)]
      ]

      pdf.table data, width: pdf.bounds.width do
        row(0).style(background_color: 'CCCCCC', font_style: :bold)
        column(1).style(align: :right)
      end
      
      pdf.move_down 10
    end

    def add_total(pdf)
      pdf.text "Total: #{number_to_delimited(@invoice.total / 100)}", size: 14, style: :bold, align: :right
      
      pdf.move_down 20
    end

    def add_payment_status(pdf)
      pdf.fill_color "008000"  # Green color
      pdf.text "PAID", size: 30, style: :bold, align: :right
      pdf.fill_color "000000"  # Reset to black

      pdf.move_down 20
    end

    def add_footer(pdf)
      pdf.text "Thank you for your business!", align: :center, size: 14, style: :italic
    end

    def format_currency(amount)
      sprintf("$%.2f", amount)
    end
  end
end