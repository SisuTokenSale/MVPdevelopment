class SourceAccount < Account
  private

  # INFO: Assign new SourceAcount to Current User InvestSet
  # TODO: Need discard all planing transactions by
  # current InvestSet, and set all another user InvestSets to disable
  def assign_to_invest_set
    return unless current_invest_set

    current_invest_set.source_account = self
    current_invest_set.save
  end
end
