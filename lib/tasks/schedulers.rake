namespace :plaid do
  namespace :fetch do
    desc 'Fetch Plaid transactions [every 10 minutes, HEROKU scheduller]'
    task transactions: :environment do
      PlaidFetchTransactionsJob.perform_now
    end
  end
end
