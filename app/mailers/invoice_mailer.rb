# app/mailers/invoice_mailer.rb
class InvoiceMailer < ApplicationMailer
  def send_invoice(invoice)
    @invoice = invoice
    @user = invoice.customer  # Assuming the invoice belongs to a user

    # Generate the PDF
    pdf = Invoices::InvoiceGenerator.call(invoice: invoice)

    # Attach the PDF to the email
    attachments["invoice_#{@invoice.public_id}.pdf"] = pdf.render

    mail(
      to: @user.email,
      subject: "Invoice ##{@invoice.public_id} for Your Recent Purchase"
    )
  end
end