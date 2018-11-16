module ProfileHelper
  def parsed_dob(dob)
    return if dob.blank?

    dob.strftime('%d/%m/%Y') rescue dob
  end
end
