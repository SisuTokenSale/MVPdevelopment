module AppExceptions
  class BaseException < StandardError
    include ActiveModel::Serialization
    attr_reader :id, :status, :code, :message

    class << self
      def model_name
        'error'
      end
    end
  end
end
