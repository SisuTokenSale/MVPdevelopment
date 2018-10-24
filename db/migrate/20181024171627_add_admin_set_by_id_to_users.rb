class AddAdminSetByIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :admin_set_by_id, :integer, index: true
  end
end
