class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  private

  def encryption_key
    Rails.application.secrets.secret_key_base[0..31]
  end
end
