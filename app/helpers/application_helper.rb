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

  def errors_in_block_for(object)
    return unless object&.errors&.any?

    message = '<div class="form-alert danger"><div id="error_explanation"><ul>'
    (object&.errors&.full_messages || []).each do |m|
      message += "<li>#{m}</li>"
    end
    "#{message}</ul></div></div>"
  end
end
