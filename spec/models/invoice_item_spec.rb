require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "relationships" do
    it { should belong_to(:invoice) }
    it { should belong_to(:item) }
    it { should have_one(:merchant).through(:item) }
    it { should have_one(:customer).through(:invoice) }
    it { should have_many(:transactions).through(:invoice) }
  end

  describe "validations" do
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:unit_price) }
    it { should validate_presence_of(:status) }
    it { should define_enum_for(:status) }
  end

  describe "#discount_applied" do
    it "returns the name of the applied discount" do
      @merchant_1 = create(:merchant)

      @customer_1 = create(:customer)

      @invoice_1 = create(:invoice, customer_id: @customer_1.id)
      @invoice_2 = create(:invoice, customer_id: @customer_1.id)

      @item_1 = create(:item, merchant_id: @merchant_1.id)
      @item_2 = create(:item, merchant_id: @merchant_1.id)

      discount_1 = @merchant_1.bulk_discounts.create!(name:"10% off 10", quantity_threshold: 10, percentage_discount: 10.0)
      discount_2 = @merchant_1.bulk_discounts.create!(name:"50% off 20", quantity_threshold: 20, percentage_discount: 50.0)

      @invoice_item_1 = create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 100)
      @invoice_item_2 = create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 20, unit_price: 100)

      expect(@invoice_item_1.discount_applied).to eq("10% off 10")
      expect(@invoice_item_2.discount_applied).to eq("50% off 20")
    end
  end

  describe "#discount_applied_object" do
    it "returnsthe applied discount object itself" do
      @merchant_1 = create(:merchant)

      @customer_1 = create(:customer)

      @invoice_1 = create(:invoice, customer_id: @customer_1.id)
      @invoice_2 = create(:invoice, customer_id: @customer_1.id)

      @item_1 = create(:item, merchant_id: @merchant_1.id)
      @item_2 = create(:item, merchant_id: @merchant_1.id)

      discount_1 = @merchant_1.bulk_discounts.create!(name:"10% off 10", quantity_threshold: 10, percentage_discount: 10.0)
      discount_2 = @merchant_1.bulk_discounts.create!(name:"50% off 20", quantity_threshold: 20, percentage_discount: 50.0)

      @invoice_item_1 = create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 100)
      @invoice_item_2 = create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 20, unit_price: 100)

      expect(@invoice_item_1.discount_applied_object).to eq(discount_1)
      expect(@invoice_item_2.discount_applied_object).to eq(discount_2)
    end
  end
end
