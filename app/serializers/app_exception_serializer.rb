class AppExceptionSerializer < ActiveModel::Serializer
  attributes :status, :code, :message
end
