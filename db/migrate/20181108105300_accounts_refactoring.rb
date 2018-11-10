class AccountsRefactoring < ActiveRecord::Migration[5.2]
  def change
    change_column :accounts, :plaid_token, :string, null: true
    add_column :accounts, :institution_id, :string
    add_column :accounts, :mask, :string

    add_column :invest_transactions, :iso_currency_code, :string
    # INFO: Set iso_currency_code from source_account for each all InvestTransactions
    InvestTransaction.where(iso_currency_code: nil).each do |it|
      it.update(iso_currency_code: it.currency.iso_code )
    end

    rename_column :profiles, :birth_date, :dob
  end
end
