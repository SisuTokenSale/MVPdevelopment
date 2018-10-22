class RemoveInvestSetsIndexes < ActiveRecord::Migration[5.2]
  def change
    remove_index :invest_sets, column: %w[source_account_id invest_account_id]
  end
end
