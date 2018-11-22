class AddTransactionLink < ActiveRecord::Migration[5.2]
  def change
    add_column :invest_transactions, :link, :string
  end
end
