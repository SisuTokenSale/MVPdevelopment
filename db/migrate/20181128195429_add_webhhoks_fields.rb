class AddWebhhoksFields < ActiveRecord::Migration[5.2]
  def change
    add_column :webhooks, :paused, :boolean, default: false
  end
end
