#Invoice Print Configurations
#Spree::Config[:admin_interface_logo]

module Spree
  class PrintInvoiceConfiguration < Preferences::Configuration
    preference :print_invoice_logo_path, :string, :default => Spree::Config[:admin_interface_logo]
    preference :print_buttons, :string, :default => 'Proforma' 
  end
end
