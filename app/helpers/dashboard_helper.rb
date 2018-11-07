module DashboardHelper
  def current_step
    return 0 if @invest_set&.ready?
    return 1 unless @source_account&.ready?
    return 2 if @source_account&.ready? && !@invest_account&.ready?
    return 3 if @source_account&.ready? && @invest_account&.ready?
  end

  def source_block_class
    current_step.in?([1]) ? 'new' : 'show'
  end

  def invest_block_class
    current_step.in?([1, 2]) ? "new #{'active' if current_step.in?([2])}" : 'show'
  end

  def invest_set_block_class
    current_step.in?([1, 2, 3]) ? "new #{'active' if current_step.in?([3])}" : 'show'
  end

  def invest_set_btn_state
    return if @invest_set&.errors&.any? || @invest_transaction&.errors&.any?

    'disabled' unless current_step.in?([0, 3])
  end

  def invest_account_btn_state
    'disabled' unless current_step.in?([0, 2, 3])
  end

  def source_account_btn_state
    ''
  end

  def transaction_class_by_status(status)
    return '' if status == 'cancelled'

    "status-#{status}"
  end
end
