class AddStrategyToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :strategy, :string
  end
end
