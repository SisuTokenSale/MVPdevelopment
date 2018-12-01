class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@#{ENV['APPLICATION_HOST']}"
  layout 'mailer'

  private

  helper_method :support_email
  def support_email
    ENV['SUPPORT_EMAIL']
  end
  helper_method :assistance_email
  def assistance_email
    'customerservice@sisutoken.io'
  end

  helper_method :dwolla_privacy_url
  def dwolla_privacy_url
    'https://www.dwolla.com/legal/privacy/'
  end

  helper_method :dwolla_terms_url
  def dwolla_terms_url
    'https://www.dwolla.com/legal/tos/'
  end
end
