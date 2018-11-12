class ApplyTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :invest_transactions, :cancelled_at, :datetime
    add_column :invest_transactions, :uid, :string
    add_column :invest_transactions, :investment_type, :string
    add_column :invest_sets, :status, :string, default: 'active', null: false
    add_column :invest_sets, :cancelled_at, :datetime

    rename_column :profiles, :dob, :tmp_dob
    rename_column :profiles, :ssn, :tmp_ssn

    change_table(:profiles) do |t|
      t.column :encrypted_dob, :string
      t.column :encrypted_ssn, :string
      t.column :encrypted_dob_iv, :string
      t.column :encrypted_ssn_iv, :string
    end

    Profile.all.each do |profile|
      profile.update(dob: profile.tmp_dob, ssn: profile.tmp_ssn)
    end

    remove_column :profiles, :tmp_dob
    remove_column :profiles, :tmp_ssn

    create_table :account_transactions, force: :cascade do |t|
      t.references :account, null: false, index: true
      t.string :uid, null: false        # INFO: plaid: transaction_id
      t.date :processed_on, null: false # INFO: plaid: date
      t.string :iso_currency_code       # INFO: plaid: iso_currency_code
      t.string :name                    # INFO: plaid: name
      t.decimal :deposit, precision: 15, scale: 10, default: 0.0, null: false # INFO: plaid: If amount > 0
      t.decimal :credit,  precision: 15, scale: 10, default: 0.0, null: false # INFO: plaid: If amount < 0
      t.timestamps null: true
      t.index %i[account_id uid], unique: true
    end
  end
end
