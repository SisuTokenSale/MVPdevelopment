module ApplicationHelper
  def bootstrap_class_for_flash(flash_type)
    case flash_type
    when 'success'
      'alert-success'
    when 'error'
      'alert-danger'
    when 'alert'
      'alert-warning'
    when 'notice'
      'alert-info'
    else
      flash_type.to_s
    end
  end

  def account_balance(account, type)
    return link_to("Add #{type} account", new_user_account_url(type: type)) unless account

    balance = account.balance || 0.0
    link_to("#{type} account balance: #{balance}", user_account_url(account.id))
  end

  def delete_account_link(account, type)
    return unless account

    link_to('X', user_account_url(account, type: type), method: :delete)
  end
end
