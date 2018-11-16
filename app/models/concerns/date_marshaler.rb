class DateMarshaler
  def self.dump(date)
    date.is_a?(String) ? date : date.to_s(:db)
  end

  def self.load(date_string)
    Date.parse(date_string)
  end
end
