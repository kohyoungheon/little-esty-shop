require 'rails_helper'

RSpec.describe 'Admin Invoices Index Page', type: :feature do
  before (:each) do
    @customer_1 = create(:customer)
    @customer_2 = create(:customer)
    @customer_3 = create(:customer)

    @merchant_1 = create(:merchant)

    @invoice_1 = create(:invoice, customer_id: @customer_1.id)
    @invoice_2 = create(:invoice, customer_id: @customer_2.id)
    @invoice_3 = create(:invoice, customer_id: @customer_3.id)

    @item_1 = create(:item, merchant_id: @merchant_1.id)
    @item_2 = create(:item, merchant_id: @merchant_1.id)

    @invoice_item_1 = create(:invoice_item,item: @item_1, invoice: @invoice_1, quantity: 10)
    @invoice_item_2 = create(:invoice_item,item: @item_2, invoice: @invoice_1, quantity: 10)
    @invoice_item_3 = create(:invoice_item,item: @item_1, invoice: @invoice_2, quantity: 10)
    @invoice_item_4 = create(:invoice_item,item: @item_2, invoice: @invoice_2, quantity: 20)

    @bulk_discount_1 = @merchant_1.bulk_discounts.create!(name: "10% off 10 Items", quantity_threshold: 10, percentage_discount: 10.0)
  end

  describe "Admin Invoices Index Page (User Story 32)" do
    it "displays all Invoice ids in system" do
      visit admin_invoices_path
      expect(page).to have_content("All Invoices:")
      expect(page).to have_content(@invoice_1.id)
      expect(page).to have_content(@invoice_2.id)
      expect(page).to have_content(@invoice_3.id)
    end

    it "Each id links to admin invoice show page" do
      visit admin_invoices_path
      expect(page).to have_link("#{@invoice_1.id}")
      click_link("#{@invoice_1.id}")
      expect(current_path).to eq(admin_invoice_path(@invoice_1))

      visit admin_invoices_path
      expect(page).to have_link("#{@invoice_2.id}")
      click_link("#{@invoice_2.id}")
      expect(current_path).to eq(admin_invoice_path(@invoice_2))
    end
  end
end