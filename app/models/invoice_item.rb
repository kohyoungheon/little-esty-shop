class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  has_one :customer, through: :invoice
  has_many :transactions, -> { distinct }, through: :invoice

  validates :quantity, presence: true, numericality: true
  validates :unit_price, presence: true, numericality: true
  validates :status, presence: true

  enum status: ["Pending", "Packaged", "Shipped"]

  def discount_applied
    BulkDiscount.joins(merchant: :items)
    .where("items.id = ?", self.item_id)
    .where("bulk_discounts.quantity_threshold <= ? AND bulk_discounts.merchant_id = ?", self.quantity, self.item.merchant_id)
    .order(percentage_discount: :desc)
    .pluck(:name)
    .first
  end

  def discount_applied_object
    BulkDiscount.joins(merchant: :items)
    .where("items.id = ?", self.item_id)
    .where("bulk_discounts.quantity_threshold <= ? AND bulk_discounts.merchant_id = ?", self.quantity, self.item.merchant_id)
    .order(percentage_discount: :desc)
    .first
  end

end
