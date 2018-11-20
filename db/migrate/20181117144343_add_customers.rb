class AddCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table 'customers', force: :cascade do |t|
      t.references 'profile', null: false, foreign_key: true, index: true
      t.string 'uid'
      t.string 'type'
      t.string 'link'
      t.string 'status', null: false, default: 'unverified'
      t.string 'customer_type', null: false
      t.timestamps null: true
      t.index %i[profile_id uid], unique: true
    end

    create_table 'funding_sources', force: :cascade do |t|
      t.references 'customer', null: false, foreign_key: true, index: true
      t.references 'account',  null: false, foreign_key: true, index: true
      t.string 'link'
      t.string 'uid'
      t.string 'status', null: false, default: 'pending'  # INFO: [pending, processed, failed]
      t.timestamps null: true
      t.index %i[account_id uid], unique: true
    end

    change_column :invest_sets, :frequency, :string, null: false, default: 'daily'
  end
end
