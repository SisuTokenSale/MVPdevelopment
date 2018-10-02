SMTP_SETTINGS = {
  address: ENV.fetch('SMTP_ADDRESS'), # INFO: example: "smtp.sendgrid.net"
  authentication: ENV.fetch('SMTP_AUTH').to_sym,
  domain: ENV.fetch('SMTP_DOMAIN'), # INFO: example: "heroku.com"
  enable_starttls_auto: true,
  password: ENV.fetch('SMTP_PASSWORD'),
  port: ENV.fetch('SMTP_PORT'),
  user_name: ENV.fetch('SMTP_USERNAME')
}.freeze
