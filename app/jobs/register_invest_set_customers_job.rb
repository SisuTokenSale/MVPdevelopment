class RegisterInvestSetCustomersJob < ApplicationJob
  queue_as :register_invest_set_customers

  def perform(opts = {})
    Processors::RegisterInvestSetCustomers.new(opts).process!
  end
end
