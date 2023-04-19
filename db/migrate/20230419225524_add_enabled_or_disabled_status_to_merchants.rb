class AddEnabledOrDisabledStatusToMerchants < ActiveRecord::Migration[5.2]
  def change
    add_column :merchants, :is_enabled, :boolean, default: false, null: false
  end
end
