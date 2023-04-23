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

  describe "5: Merchant Bulk Discount Edit" do
    it "displays a link to edit bulk discount" do
      visit merchant_bulk_discount_path(@merchant_1,@bulk_discount_1)
      expect(page).to have_content("Edit this Discount")

      visit merchant_bulk_discount_path(@merchant_2,@bulk_discount_3)
      expect(page).to have_content("Edit this Discount")
    end
    it "clicking this link takes me to a new page with prefilled form" do
      visit merchant_bulk_discount_path(@merchant_1,@bulk_discount_1)
      click_link("Edit this Discount")
      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant_1,@bulk_discount_1))
      expect(page).to have_field("bulk_discount_name", with: @bulk_discount_1.name)
      expect(page).to have_field("bulk_discount_quantity_threshold", with: @bulk_discount_1.quantity_threshold)
      expect(page).to have_field("bulk_discount_percentage_discount", with: @bulk_discount_1.percentage_discount)
    end
    it "changing form and submitting redirects to show page with new information" do
      visit merchant_bulk_discount_path(@merchant_1,@bulk_discount_1)
      click_link("Edit this Discount")
      fill_in "bulk_discount_name", with: "Test Discount 1"
      fill_in "bulk_discount_quantity_threshold", with: "99"
      fill_in "bulk_discount_percentage_discount", with: "99"
      click_button "commit"
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant_1,@bulk_discount_1))

      expect(page).to have_content("Test Discount 1")
      expect(page).to have_content("Threshold: 99")
      expect(page).to have_content("Percentage Discount: 99.0")

      expect(page).to_not have_content("20% off 20 Items")
      expect(page).to_not have_content("Quantity Threshold: 20")
      expect(page).to_not have_content("Percentage Discount: 20.0")
    end
  end
end
# 5: Merchant Bulk Discount Edit

# As a merchant
# When I visit my bulk discount show page
# Then I see a link to edit the bulk discount
# When I click this link
# Then I am taken to a new page with a form to edit the discount
# And I see that the discounts current attributes are pre-poluated in the form
# When I change any/all of the information and click submit
# Then I am redirected to the bulk discount's show page
# And I see that the discount's attributes have been updated