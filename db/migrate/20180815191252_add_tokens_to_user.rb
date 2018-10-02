class AddTokensToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :access_token, :string
    add_column :users, :processor_token, :string
    add_column :users, :dwolla_customer_url, :string
  end
end
