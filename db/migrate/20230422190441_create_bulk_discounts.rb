class CreateBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_discounts do |t|
      t.string :name
      t.integer :quantity_threshold
      t.float :percentage_discount
      t.timestamps
      t.references :merchant, foreign_key: true
    end
  end
end
