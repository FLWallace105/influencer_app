class OrderInterval < ApplicationRecord
  validates_presence_of :start_date
  validates_presence_of :end_date

  validate :end_date_after_start_date

  

  def create_date_from_string(year, month, day)
    puts "#{year}, #{month}, #{day}"
    if month.to_i < 9
        month = "0#{month.to_i}"
    end
    temp_date = "#{year}-#{month}-#{day}"
    new_date = Date.strptime(temp_date, "%Y-%m-%e")
    
    
  end

  def create_usage_from_integer(usage)
    if usage.to_i == 1
        return true
    else
        return false
    end
  end



  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end


end
