class InvestSetMinRelBalance < ActiveRecord::Migration[5.2]
  def change
    add_column :invest_sets, :rel_min_balance, :decimal, precision: 15, scale: 10, default: 5.0, null: false
  end
end
