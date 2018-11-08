class AddDocumentToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :document, :string
  end
end
