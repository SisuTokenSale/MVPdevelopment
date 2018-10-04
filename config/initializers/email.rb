Mail.register_interceptor RecipientInterceptor.new(ENV['EMAIL_RECIPIENTS']) if ENV['EMAIL_RECIPIENTS'].present?
