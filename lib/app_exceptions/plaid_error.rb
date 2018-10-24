module AppExceptions
  class PlaidError < AppExceptions::BaseException
    def initialize(*args)
      raise ArgumentError, 'Error instance variable should be present' unless args

      @code = 422
      @status = args[0].error_code
      @message = args[0].error_message&.split(':')&.first
    end
  end
end
