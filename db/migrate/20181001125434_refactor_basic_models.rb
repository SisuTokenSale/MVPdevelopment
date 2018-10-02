class RefactorBasicModels < ActiveRecord::Migration[5.2]
  def change
    # remove_column :accounts, :balance
    change_column :accounts, :balance, :decimal, precision: 15, scale: 10, default: 0.0, null: false
    change_column :accounts, :account_id, :string,  null: false
    change_column :accounts, :user_id,    :integer, null: false
  end
end
