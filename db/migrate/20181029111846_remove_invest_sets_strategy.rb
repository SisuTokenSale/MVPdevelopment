class RemoveInvestSetsStrategy < ActiveRecord::Migration[5.2]
  def change
    remove_column :invest_sets, :strategy
    remove_index  :invest_transactions, :source_account_id
    remove_index  :invest_transactions, :invest_account_id
    remove_column :invest_transactions, :source_account_id
    remove_column :invest_transactions, :invest_account_id
    add_column :accounts, :plaid_identity, :text #, null: false, default: '{}'
  end
end
