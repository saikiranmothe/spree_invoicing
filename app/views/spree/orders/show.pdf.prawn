
  require 'prawn'
  require 'prawn/layout'

  @date = 

  #Logo company
  ##################################
             pdf.font "Helvetica"
             pdf.image "#{Rails.root.to_s}/app/assets/images/#{Spree::PrintInvoiceConfig[:print_invoice_logo_path]}" ,width:180 ,height:60

             pdf.move_up 50

  #Company Details
  ##################################
  y_position = pdf.cursor - 10
  pdf.bounding_box([350, y_position], width: 200, height: 100) do
  pdf.transparent(0.0) { pdf.stroke_bounds }
             pdf.text "Admin Off : #{Spree::Company::Config.company_address_number}," 
             pdf.text "#{Spree::Company::Config.company_street}," ,align:  :center
             pdf.text "#{Spree::Company::Config.company_city} - #{Spree::Company::Config.company_zip}." ,align:  :center
             pdf.text "Contact : #{Spree::Company::Config.company_phone}"
             pdf.text "Email : #{Spree::Company::Config.company_email}"
             pdf.text "Website : #{Spree::Company::Config.company_website}"

   pdf.move_down 10
   
             #pdf.text " VAT Number : #{Spree::Company::Config.company_vatnumber}"
end
             pdf.text "Purchase Proforma",size: 25  ,style: :bold ,align:  :center
             #pdf.stroke_horizontal_rule

  pdf.move_down 10

  #Company Name && Company Slogan
  ##################################

 # pdf.text "#{Spree::Company::Config.company_name}",style: :bold,size: 20
 # pdf.text "#{Spree::Company::Config.company_slogan} "

 # pdf.move_down 10

  #Company Details
  ##################################

  #y_position = pdf.cursor - 10
  #pdf.bounding_box([0, y_position], width: 250, height: 150) do
  #pdf.transparent(0.0) { pdf.stroke_bounds }
  # pdf.text "Company Address",style: :bold
  # pdf.move_down 5
  #     pdf.text "#{Spree::Company::Config.company_address_number}" 
  #     pdf.text "#{Spree::Company::Config.company_street}"
  #     pdf.text "#{Spree::Company::Config.company_city} - #{Spree::Company::Config.company_zip}        "
  #     pdf.text "Contact : #{Spree::Company::Config.company_phone}"
  #     pdf.text "#{Spree::Company::Config.company_website}  #{Spree::Company::Config.company_email}"
  #     pdf.text " VAT Number : #{Spree::Company::Config.company_vatnumber}"
  #end

  #Invoice Details
  ##################################

  #pdf.bounding_box([300, y_position], width: 250, height: 150) do
  #pdf.transparent(0.0) { pdf.stroke_bounds }
  #  pdf.text "Transaction  : #{@order.created_at.strftime("%d-%m-%Y")}", align: :right
  #  pdf.text "INVOICE NUMBER : #{(@order.number.to_s)}"  ,align: :right
  #  pdf.move_down 4

#Company Account Details
  ##################################
 
  #  pdf.text "Payment Particulars"
  # pdf.move_down 5
  #  pdf.text  "Name of the Beneficiary : #{Spree::Company::Config.company_beneficiary}"
  #  pdf.text "Name of the Bank : #{Spree::Company::Config.company_bankname}"
  #  pdf.text "Bank Branch  : #{Spree::Company::Config.company_branchname}"
  #  pdf.text "Bank Account Number : #{Spree::Company::Config.company_account_number}"
  #  pdf.text "BANK RTGS CODE :  #{Spree::Company::Config.company_rtgscode}"

 # end


  #Billing Address Details
  ##################################
  y_position = pdf.cursor - 10
  pdf.bounding_box([0, y_position], width: 200, height: 100) do
    pdf.transparent(0.0) { pdf.stroke_bounds }
    pdf.text "To:",size:15 , style: :bold,align: :left
    pdf.text "#{@order.bill_address.first_name}  #{@order.bill_address.lastname}"
    pdf.text "#{@order.bill_address.address1}  #{@order.bill_address.address2}"
    pdf.text "#{@order.bill_address.city} #{@order.bill_address.state_name} #{@order.bill_address.zipcode}"
    pdf.text "#{@order.bill_address.vat_number}"
  end

  #Shipping Address Details
  ##################################

  pdf.bounding_box([300, y_position], width: 200, height: 100) do
    pdf.transparent(0.0) { pdf.stroke_bounds }
    pdf.text "SHIP To:",size:15 , style: :bold,align: :left
    pdf.text "#{@order.ship_address.first_name}  #{@order.ship_address.lastname}"
    pdf.text "#{@order.ship_address.address1}  #{@order.ship_address.address2}"
    pdf.text "#{@order.ship_address.city} #{@order.ship_address.state_name} #{@order.ship_address.zipcode}"
    pdf.text "Phone : #{@order.ship_address.phone}"
  end

  # Information Comments  Ends Here.
  ##################################

  #pdf.text "COMMENTS OR SPECIAL INSTRUCTIONS",style: :bold
  #pdf.text "#{@order.special_instructions.inspect}",style: :bold
  #pdf. stroke_horizontal_rule


  # Order Information // Line Items
  ##################################
  # Information Comments  Ends Here.
  ##################################
  pdf.move_down 10
  pdf.stroke_horizontal_rule

   @order.line_items.each do |item|
   @name= item.variant.product.name
   @item_price = number_to_currency(item.price)
   @quantity = item.quantity.to_s
   @total = number_to_currency(item.price * item.quantity)
   #@discount = number_to_currency(-1 * item.discount)
   #@total_discount = number_to_currency(-1 * item.discount * item.quantity)
   @name1 = item.variant.options_text.inspect
   end
    
   @order.adjustments.eligible.each do |adjustment|
      next if (adjustment.originator_type == 'Spree::TaxRate') and (adjustment.amount == 0)
     next if (adjustment.amount == 0)
     @product_adjustment_label =  adjustment.label
     @product_adjustment = number_to_currency adjustment.amount
    end

    @subtotal =

  # LIne Items / Order Data in Table
  ##################################

    pdf.table([ ["Quantity","Description","Unit Price","VAT(5%)","Total"],
                ["#{@quantity}","#{@name}","#{@item_price}","#{number_to_currency  @order.tax_total}",
                  "#{@order.display_item_total}"],
                ["","",""," Sub-Total","#{@order.display_item_total}"],
                ["","","","Vat","#{number_to_currency @order.tax_total}"],
                ["","","","Shipping & Handling","#{@order.display_ship_total}"],
                ["","","","Coupon Discount",""],
                ["","","","Total Due","#{@order.display_total}"]
              ],:column_widths => [60, 180, 80, 100, 120], cell_style: {align: :center})
  
  # RTGS DETAILS
  ########################
   
    pdf.move_down 10
    pdf.text "OUR RTGS DETAILS:", style: :bold,size:15
    pdf.move_down 5
    pdf.text  "NAME : #{Spree::Company::Config.company_beneficiary}" 
    pdf.move_down 5 
    pdf.text "BANK NAME : #{Spree::Company::Config.company_bankname}"
    pdf.move_down 5
    pdf.text "BRANCH : #{Spree::Company::Config.company_branchname}"
    pdf.move_down 5
    pdf.text "ACCOUNT NUMBER : #{Spree::Company::Config.company_account_number}"
    pdf.move_down 5
    pdf.text "RTGS CODE :  #{Spree::Company::Config.company_rtgscode}"

  #  Footer
  ##############################################

   pdf.move_cursor_to 45
   pdf.stroke_horizontal_rule
   pdf.move_down 5
       pdf.text "* This is a Computer Generated Purchase Proforma & requires no Signature"
   pdf.text "Contact :: #{Spree::Company::Config.company_name},#{Spree::Company::Config.company_phone} or #{Spree::Company::Config.company_email}",style: :bold

  #  PDF ENDS HERE
  ##############################################
