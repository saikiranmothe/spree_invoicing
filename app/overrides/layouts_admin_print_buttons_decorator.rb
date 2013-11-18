#Added Bulk Generation Button in Admin Reports.
  Deface::Override.new(:virtual_path => "spree/admin/reports/index",
                       :name => 'printbuttons',
                       :insert_after => "[data-hook='reports_header']",
                       :partial => "spree/admin/orders/print_buttons1"
                       )

#Added Print Invoice to Order show page in Admin.
  Deface::Override.new(:virtual_path  => "spree/layouts/admin",
                       :insert_after => "[data-hook='toolbar']",
                       :partial => "spree/admin/orders/print_buttons",
                       :name => "Invoices"
                       )


#Added Invoice for Users Account.
  Deface::Override.new(:virtual_path => %q{spree/orders/show},
                       :insert_before => "div#order",
                       :name => "invoiceprint",
                       :partial => "spree/admin/orders/print_buttons2"
                      )
