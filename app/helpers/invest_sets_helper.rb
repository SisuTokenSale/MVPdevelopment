module InvestSetsHelper
  def frequency_checked?(value)
    return unless @invest_set

    value == @invest_set&.frequency ? 'checked' : ''
  end

  def account_status(account)
    status_span(account&.ready?)
  end

  def invest_set_status
    status_span(@invest_set&.ready?)
  end

  private

  def status_span(status)
    '[<span class="text-' + (status ? 'success">Ready' : 'danger">Pending') + '</span>]'
  end
end
