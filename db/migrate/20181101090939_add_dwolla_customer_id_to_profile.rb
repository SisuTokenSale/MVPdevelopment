class AddDwollaCustomerIdToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :dwolla_customer_uid, :string
  end
end
