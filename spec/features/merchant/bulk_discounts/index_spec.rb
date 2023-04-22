require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Index Page', type: :feature do
  before(:each) do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)

    @bulk_discount_1 = @merchant_1.bulk_discounts.create!(name: "20% off 20 Items", quantity_threshold: 20, percentage_discount: 20.0)
    @bulk_discount_2 = @merchant_1.bulk_discounts.create!(name: "10% off 10 Items", quantity_threshold: 10, percentage_discount: 10.0)
    @bulk_discount_3 = @merchant_2.bulk_discounts.create!(name: "5% off 5 Items", quantity_threshold: 50, percentage_discount: 5.0)
  end

  describe "2: Merchant Bulk Discount Create" do
    it "displays a link to create a new discount" do
      visit merchant_bulk_discounts_path(@merchant_1)
      expect(page).to have_link("Create a New Discount")
      visit merchant_bulk_discounts_path(@merchant_2)
      expect(page).to have_link("Create a New Discount")
    end
    it "link takes me to a new page with empty form" do
      visit merchant_bulk_discounts_path(@merchant_1)
      click_link("Create a New Discount")
      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1))
      expect(page).to have_field("bulk_discount_name")
      expect(page).to have_field("bulk_discount_percentage_discount")
      expect(page).to have_field("bulk_discount_quantity_threshold")
    end
    it "filling and submitting form redirects me to bulk discount index where I see new discount" do
      visit new_merchant_bulk_discount_path(@merchant_1)
      fill_in("bulk_discount_name", with: "50% off 50 Items")
      fill_in("bulk_discount_percentage_discount", with: "50.0")
      fill_in("bulk_discount_quantity_threshold", with: "50")
      click_button("commit")
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))
      expect(page).to have_content("Name: 50% off 50 Items")
      expect(page).to have_content("Percentage Discount: 50.0")
      expect(page).to have_content("Quantity Threshold: 50")
    end

    it "not completely filling the form displays error and renders same page" do
      visit new_merchant_bulk_discount_path(@merchant_1)
      fill_in("bulk_discount_name", with: "")
      fill_in("bulk_discount_percentage_discount", with: "50.0")
      fill_in("bulk_discount_quantity_threshold", with: "50")
      click_button("commit")
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))
      expect(page).to have_content("Error: Name can't be blank")
    end
  end

  describe "3: Merchant Bulk Discount Delete" do
    it "displays a link to delete next to each bulk discount" do
      visit merchant_bulk_discounts_path(@merchant_1)
      expect(page).to have_content("20% off 20 Items")
      expect(page).to have_content("10% off 10 Items")

      within ("##{@bulk_discount_1.id}_discount") do
        expect(page).to have_link("Delete")
      end
      within ("##{@bulk_discount_2.id}_discount") do
        expect(page).to have_link("Delete")
      end
    end
    it "clicking redirects me to bulk discounts index page where discount is gone" do
      visit merchant_bulk_discounts_path(@merchant_1)

      expect(page).to have_content("20% off 20 Items")
      expect(page).to have_content("10% off 10 Items")

      within ("##{@bulk_discount_1.id}_discount") do
        click_link("Delete")
      end
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))
      expect(page).to have_content("10% off 10 Items")

      expect(page).to_not have_content("20% off 20 Items")
    end
  end
end
