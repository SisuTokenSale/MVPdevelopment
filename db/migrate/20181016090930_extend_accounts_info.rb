class ExtendAccountsInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :name, :string
    add_column :accounts, :institution, :string
    add_column :accounts, :account_type, :string
    add_column :accounts, :iso_currency_code, :string
  end
end
