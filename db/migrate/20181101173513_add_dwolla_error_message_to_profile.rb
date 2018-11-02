class AddDwollaErrorMessageToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :dwolla_error_message, :string
  end
end
