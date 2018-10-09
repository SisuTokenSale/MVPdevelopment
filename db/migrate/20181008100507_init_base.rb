class InitBase < ActiveRecord::Migration[5.2]
  def change
    create_table 'users', force: :cascade do |t|
      t.string 'email', default: '', null: false
      t.string 'encrypted_password', default: '', null: false
      t.string 'reset_password_token'
      t.datetime 'reset_password_sent_at'
      t.datetime 'remember_created_at'
      t.integer 'sign_in_count', default: 0, null: false
      t.datetime 'current_sign_in_at'
      t.datetime 'last_sign_in_at'
      t.inet 'current_sign_in_ip'
      t.inet 'last_sign_in_ip'
      t.string 'role', default: 'user'
      t.timestamps null: true
      t.index ['email'], unique: true
      t.index ['reset_password_token'], unique: true
    end

    create_table 'accounts', force: :cascade do |t|
      t.references 'user',     null: false, foreign_key: true
      t.string 'plaid_token',  null: false
      # INFO: 'uid' can be null for able to select account
      # from available accounts list by plaid_token
      t.string 'uid'
      # INFO: 'dwolla_token' can be null because related to existing 'uid',
      # Will get after save if plaid_token && uid exist
      t.string 'dwolla_token'
      t.string 'type'
      t.decimal 'balance', precision: 15, scale: 10, default: 0.0, null: false
      t.timestamps null: true
      t.index %w[plaid_token uid dwolla_token], unique: true
    end

    create_table 'invest_sets', force: :cascade do |t|
      t.references 'user',           null: false, foreign_key: true
      t.references 'source_account', null: false, index: true
      t.references 'invest_account', null: false, index: true
      t.string 'strategy'  # INFO: [default, algo]
      t.string 'frequency', null: false, default: 'once' # INFO: [once, daily, weekly, monthly]
      t.integer 'lowest'   # INFO: Percentage of lowest balace of the month
      t.decimal 'amount', precision: 15, scale: 10, default: 0.0, null: false
      t.timestamps null: true
      t.index %w[source_account_id invest_account_id], unique: true
    end

    create_table 'invest_transactions', force: :cascade do |t|
      t.references 'invest_set',     null: false, foreign_key: true
      t.references 'source_account', null: false, index: true
      t.references 'invest_account', null: false, index: true
      t.string 'status', null: false, default: 'planned' # INFO: [planned, pending, processed, cancelled, failed]
      t.decimal 'amount', precision: 15, scale: 10, default: 0.0, null: false
      t.string 'description'
      t.timestamps null: true
    end
  end
end
