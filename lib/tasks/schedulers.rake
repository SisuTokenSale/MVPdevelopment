namespace :plaid do
  namespace :fetch do
    desc 'Fetch Plaid transactions [every 10 minutes, HEROKU scheduller]'
    task transactions: :environment do
      PlaidFetchTransactionsJob.perform_now
    end

    desc 'Fetch Balances of Accounts in active InvestSets [evey hour, HEROKU scheduller]'
    task balances: :environment do
      PlaidFetchBalancesJob.perform_now
    end
  end
end

namespace :dwolla do
  namespace :fetch do
    desc 'Fetch DwollaWebhooks [evey 10 minutes, HEROKU scheduller]'
    task webhooks: :environment do
      DwollaFetchWebhooksJob.perform_now
    end
  end

  namespace :process do
    desc 'Process Invest Transactions [evey hour, HEROKU scheduller]'
    task invest_transactions: :environment do
      InvestTransactionsJob.perform_now
    end
  end
end
