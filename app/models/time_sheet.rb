class TimeSheet < ApplicationRecord
  validates :working_date, :start_time, :end_time, :working_fee, presence: true
  validates :working_date, uniqueness: true

  validate :validate_future_day
  validate :validate_end_time
  
  def validate_future_day
    if working_date > DateTime.now
      errors.add(:working_date, "must be not in the future")
    end
  end

  def validate_end_time
    if end_time < start_time
      errors.add(:end_time ," cannot be before start time")
    end
  end
end
