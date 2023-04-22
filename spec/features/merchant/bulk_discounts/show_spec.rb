require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Show Page', type: :feature do
  before(:each) do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)

    @bulk_discount_1 = @merchant_1.bulk_discounts.create!(name: "20% off 20 Items", quantity_threshold: 20, percentage_discount: 20.0)
    @bulk_discount_2 = @merchant_1.bulk_discounts.create!(name: "10% off 10 Items", quantity_threshold: 10, percentage_discount: 10.0)
    @bulk_discount_3 = @merchant_2.bulk_discounts.create!(name: "5% off 5 Items", quantity_threshold: 50, percentage_discount: 5.0)
  end

  describe "4: Merchant Bulk Discount Show" do
    it "displays the bulk discount's quantity threshold and percentage discount" do
      visit merchant_bulk_discount_path(@merchant_1,@bulk_discount_1)

      expect(page).to have_content("20% off 20 Items")
      expect(page).to have_content("Quantity Threshold: 20")
      expect(page).to have_content("Percentage Discount: 20.0")

      expect(page).to_not have_content("5% off 5 Items")
      expect(page).to_not have_content("Quantity Threshold: 5")
      expect(page).to_not have_content("Percentage Discount: 5.0")

      visit merchant_bulk_discount_path(@merchant_1,@bulk_discount_2)

      expect(page).to have_content("10% off 10 Items")
      expect(page).to have_content("Quantity Threshold: 10")
      expect(page).to have_content("Percentage Discount: 10.0")

      expect(page).to_not have_content("5% off 5 Items")
      expect(page).to_not have_content("Quantity Threshold: 5")
      expect(page).to_not have_content("Percentage Discount: 5.0")

      visit merchant_bulk_discount_path(@merchant_2,@bulk_discount_3)

      expect(page).to have_content("5% off 5 Items")
      expect(page).to have_content("Quantity Threshold: 5")
      expect(page).to have_content("Percentage Discount: 5.0")

      expect(page).to_not have_content("10% off 10 Items")
      expect(page).to_not have_content("Quantity Threshold: 10")
      expect(page).to_not have_content("Percentage Discount: 10.0")
    end
  end
end