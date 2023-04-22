require 'rails_helper'

RSpec.describe 'Merchant Dashboard Page', type: :feature do
  before(:each) do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)

    @item_1 = create(:item, merchant_id: @merchant_1.id, is_enabled: true)
    @item_2 = create(:item, merchant_id: @merchant_1.id, is_enabled: true)
    @item_3 = create(:item, merchant_id: @merchant_1.id, is_enabled: true)
    @item_4 = create(:item, merchant_id: @merchant_1.id)
    @item_5 = create(:item, merchant_id: @merchant_1.id)

    @customer_1 = create(:customer)
    @customer_2 = create(:customer)
    @customer_3 = create(:customer)
    @customer_4 = create(:customer)
    @customer_5 = create(:customer)
    @customer_6 = create(:customer)

    @invoice_1 = create(:invoice, customer_id: @customer_1.id, created_at: "2012-03-27 14:54:09")
    @invoice_2 = create(:invoice, customer_id: @customer_1.id, created_at: "2011-03-27 14:54:09")
    @invoice_3 = create(:invoice, customer_id: @customer_2.id, created_at: "2009-03-27 14:54:09")
    @invoice_4 = create(:invoice, customer_id: @customer_3.id, created_at: "2010-03-27 14:54:09")
    @invoice_5 = create(:invoice, customer_id: @customer_4.id)
    @invoice_6 = create(:invoice, customer_id: @customer_5.id)
    @invoice_7 = create(:invoice, customer_id: @customer_6.id)

    @transaction_1 = create(:transaction, invoice_id: @invoice_1.id, result: true) #customer_1
    @transaction_2 = create(:transaction, invoice_id: @invoice_1.id, result: true) #customer_1
    @transaction_3 = create(:transaction, invoice_id: @invoice_2.id, result: true) #customer_1
    @transaction_4 = create(:transaction, invoice_id: @invoice_2.id, result: true) #customer_1
    @transaction_5 = create(:transaction, invoice_id: @invoice_2.id, result: true) #customer_1
    @transaction_6 = create(:transaction, invoice_id: @invoice_2.id, result: true) #customer_1
    @transaction_7 = create(:transaction, invoice_id: @invoice_3.id, result: true) #customer_2
    @transaction_8 = create(:transaction, invoice_id: @invoice_3.id, result: true) #customer_2
    @transaction_9 = create(:transaction, invoice_id: @invoice_3.id, result: true) #customer_2
    @transaction_10 = create(:transaction, invoice_id: @invoice_3.id, result: true) #customer_2
    @transaction_11 = create(:transaction, invoice_id: @invoice_3.id, result: true) #customer_2
    @transaction_12 = create(:transaction, invoice_id: @invoice_4.id, result: true) #customer_3
    @transaction_13 = create(:transaction, invoice_id: @invoice_4.id, result: true) #customer_3
    @transaction_14 = create(:transaction, invoice_id: @invoice_4.id, result: true) #customer_3
    @transaction_15 = create(:transaction, invoice_id: @invoice_4.id, result: true) #customer_3
    @transaction_16 = create(:transaction, invoice_id: @invoice_5.id, result: true) #customer_4
    @transaction_17 = create(:transaction, invoice_id: @invoice_5.id, result: true) #customer_4
    @transaction_18 = create(:transaction, invoice_id: @invoice_5.id, result: true) #customer_4
    @transaction_19 = create(:transaction, invoice_id: @invoice_6.id, result: true) #customer_5
    @transaction_20 = create(:transaction, invoice_id: @invoice_6.id, result: true) #customer_5
    @transaction_21 = create(:transaction, invoice_id: @invoice_6.id, result: false) #customer_5
    @transaction_22 = create(:transaction, invoice_id: @invoice_7.id, result: true) #customer_6
    @transaction_23 = create(:transaction, invoice_id: @invoice_7.id, result: false) #customer_6

    @invoice_item_1 = create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, status: 0)
    @invoice_item_2 = create(:invoice_item, item_id: @item_2.id, invoice_id: @invoice_2.id, status: 0)
    @invoice_item_3 = create(:invoice_item, item_id: @item_3.id, invoice_id: @invoice_3.id, status: 1)
    @invoice_item_4 = create(:invoice_item, item_id: @item_4.id, invoice_id: @invoice_4.id, status: 1)
    @invoice_item_5 = create(:invoice_item, item_id: @item_5.id, invoice_id: @invoice_5.id, status: 2)
    @invoice_item_6 = create(:invoice_item, item_id: @item_5.id, invoice_id: @invoice_6.id, status: 2)
    @invoice_item_7 = create(:invoice_item, item_id: @item_5.id, invoice_id: @invoice_7.id, status: 2)

    @bulk_discount_1 = @merchant_1.bulk_discounts.create!(name: "20% off 20 Items", quantity_threshold: 20, percentage_discount: 20.0)
    @bulk_discount_2 = @merchant_1.bulk_discounts.create!(name: "10% off 10 Items", quantity_threshold: 10, percentage_discount: 10.0)
    @bulk_discount_3 = @merchant_2.bulk_discounts.create!(name: "5% off 5 Items", quantity_threshold: 50, percentage_discount: 5.0)

    visit merchant_dashboard_path(@merchant_1.id)
  end

  it 'has a header' do
    expect(page).to have_content('Little Esty Shop')
  end

  it 'has the merchant name; User Story 1' do
    expect(page).to have_content(@merchant_1.name)
  end

  it 'has a link to the merchant items index; User Story 2' do
    expect(page).to have_link('Items Index')

    click_link('Items Index')

    expect(current_path).to eq(merchant_items_path(@merchant_1.id))
  end

  it 'has a link to the merchant invoices index; User Story 2' do
    expect(page).to have_link('Invoices Index')

    click_link('Invoices Index')

    expect(current_path).to eq(merchant_invoices_path(@merchant_1.id))
  end

  it 'has a list of the top 5 customers (User Story 3)' do
    expect(page).to have_content('Top 5 Customers')
  end

  it 'lists all five customers with the most successful transactions (User Story 3)' do
    within "#top-five-#{@customer_1.id}" do
      expect(page).to have_content(@customer_1.first_name + " " + @customer_1.last_name + " - 6 transactions")
    end

    within "#top-five-#{@customer_2.id}" do
      expect(page).to have_content(@customer_2.first_name + " " + @customer_2.last_name + " - 5 transactions")
    end

    within "#top-five-#{@customer_3.id}" do
      expect(page).to have_content(@customer_3.first_name + " " + @customer_3.last_name + " - 4 transactions")
    end

    within "#top-five-#{@customer_4.id}" do
      expect(page).to have_content(@customer_4.first_name + " " + @customer_4.last_name + " - 3 transactions")
    end

    within "#top-five-#{@customer_5.id}" do
      expect(page).to have_content(@customer_5.first_name + " " + @customer_5.last_name + " - 2 transactions")
    end
  end

  it 'has a section for "Items Ready to Ship" (User Story 4)' do
    expect(page).to have_content('Items Ready to Ship')
  end

  it 'lists the names of all of my items that have been ordered and have not yet been shipped, its invoice id as a link (User Story 4)' do
    within "#invoice-item-#{@invoice_item_1.id}" do
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@invoice_1.id)
    end

    within "#invoice-item-#{@invoice_item_2.id}" do
      expect(page).to have_content(@item_2.name)
      expect(page).to have_content(@invoice_2.id)
    end

    within "#invoice-item-#{@invoice_item_3.id}" do
      expect(page).to have_content(@item_3.name)
      expect(page).to have_content(@invoice_3.id)
    end

    within "#invoice-item-#{@invoice_item_4.id}" do
      expect(page).to have_content(@item_4.name)
      expect(page).to have_content(@invoice_4.id)
    end
  end

  it 'the links will take me to my merchant invoice show page (User Story 4)' do
    within "#invoice-item-#{@invoice_item_1.id}" do
      expect(page).to have_link(@invoice_1.id.to_s)

      click_link(@invoice_1.id.to_s)

      expect(current_path).to eq(merchant_invoice_path(@merchant_1, @invoice_1))
    end
  end

  it 'has the date the invoice was created at formatted like "Tuesday, March 27, 2012" (User Story 5)' do
    within "#invoice-item-#{@invoice_item_1.id}" do
      expect(page).to have_content("Tuesday, March 27, 2012")
    end
  end

  it 'should order them from oldest to newest (User Story 5)' do
    expect(@item_3.name).to appear_before(@item_4.name)
    expect(@item_4.name).to appear_before(@item_2.name)
    expect(@item_2.name).to appear_before(@item_1.name)
  end

  it 'should show a random photo by the merchant name (API 39)' do
    within "#photo" do
      expect(page).to have_css("img")
    end
  end

  it 'shows random photos for multiple merchants' do
    visit merchant_dashboard_path(@merchant_2.id)

    within "#photo" do
      expect(page).to have_css("img")
    end
  end

  describe "1: Merchant Bulk Discounts Index" do
    it "displays a link to view all discounts" do
      expect(page).to have_link("View all my discounts")
      visit merchant_dashboard_path(@merchant_2.id)
      expect(page).to have_link("View all my discounts")
    end
    it "link takes me to bulk discounts index page" do
      click_link("View all my discounts")
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))

      visit merchant_dashboard_path(@merchant_2.id)
      click_link("View all my discounts")
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_2))
    end
    it "displays percentage and quantity attributes and a link to it's show page" do
      click_link("View all my discounts")
      within ("##{@bulk_discount_1.id}_discount") do
        expect(page).to have_content("Name: #{@bulk_discount_1.name}")
        expect(page).to have_content("Quantity Threshold: #{@bulk_discount_1.quantity_threshold}")
        expect(page).to have_content("Percentage Discount: #{@bulk_discount_1.percentage_discount}")
        
        expect(page).to_not have_content("Name: #{@bulk_discount_3.name}")
        expect(page).to_not have_content("Quantity Threshold: #{@bulk_discount_3.quantity_threshold}")
        expect(page).to_not have_content("Percentage Discount: #{@bulk_discount_3.percentage_discount}")

        expect(page).to have_link("(View Discount #{@bulk_discount_1.id})")
        click_link("(View Discount #{@bulk_discount_1.id})")
        expect(current_path).to eq(merchant_bulk_discount_path(@merchant_1, @bulk_discount_1))
      end

      visit merchant_dashboard_path(@merchant_2.id)
      click_link("View all my discounts")
      within ("##{@bulk_discount_3.id}_discount") do
        expect(page).to have_content("Name: #{@bulk_discount_3.name}")
        expect(page).to have_content("Quantity Threshold: #{@bulk_discount_3.quantity_threshold}")
        expect(page).to have_content("Percentage Discount: #{@bulk_discount_3.percentage_discount}")

        expect(page).to_not have_content("Name: #{@bulk_discount_1.name}")
        expect(page).to_not have_content("Quantity Threshold: #{@bulk_discount_1.quantity_threshold}")
        expect(page).to_not have_content("Percentage Discount: #{@bulk_discount_1.percentage_discount}")

        expect(page).to have_link("(View Discount #{@bulk_discount_3.id})")
        click_link("(View Discount #{@bulk_discount_3.id})")
        expect(current_path).to eq(merchant_bulk_discount_path(@merchant_2, @bulk_discount_3))
      end
    end
  end
end
