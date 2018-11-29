class WillProcessedAtTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :invest_transactions, :will_processed_at, :datetime
    add_column :invest_transactions, :processed_at, :datetime
  end
end
