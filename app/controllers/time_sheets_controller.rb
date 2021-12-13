class TimeSheetsController < ApplicationController
  WEEK_DAYS = {
    '0': 'GROUP_3', # Sunday
    '1': 'GROUP_1', # Monday
    '2': 'GROUP_2', # Tuesday
    '3': 'GROUP_1', # Wednesday
    '4': 'GROUP_2', # Thursday
    '5': 'GROUP_1', # Friday
    '6': 'GROUP_3', # Saturday
  }
  TIME = {
    GROUP_1: {
      start_time: 7,
      end_time: 19
    },
    GROUP_2: {
      start_time: 5,
      end_time: 17
    },
    GROUP_3: {
      start_time: 8,
      end_time: 16
    }
  }
  FEE = {
    GROUP_1: 22,
    GROUP_2: 25,
    GROUP_3: 47
  }
  OT_FEE = {
    GROUP_1: 34,
    GROUP_2: 35,
    GROUP_3: 47
  }

  def index
    @time_sheets = TimeSheet.order(:working_date)
  end

  def new
    @time_sheet = TimeSheet.new
  end

  def create
    # date
    input_day = time_sheet_params["working_date(3i)"]
    input_month = time_sheet_params["working_date(2i)"]
    input_year = time_sheet_params["working_date(1i)"]
    date = Date.new(input_year.to_i, input_month.to_i, input_day.to_i)
    group = WEEK_DAYS[date.wday.to_s.to_sym]

    # start time
    input_st_time_h = time_sheet_params["start_time(4i)"].to_i
    input_st_time_m = time_sheet_params["start_time(5i)"].to_f
    start_time = change_time_format(input_st_time_h, input_st_time_m)
    formt_time_start = "#{input_st_time_h}:#{input_st_time_m}"

    # end time
    input_end_time_h = time_sheet_params["end_time(4i)"].to_i
    input_end_time_m = time_sheet_params["end_time(5i)"].to_f
    end_time = change_time_format(input_end_time_h, input_end_time_m)
    formt_time_end = "#{input_end_time_h}:#{input_end_time_m}"

    # working time and amount
    working_time = detect_working_time(start_time, end_time, group)
    total_fee = calculate_fee(working_time, group)
    @time_sheet = TimeSheet.new(working_date: date, start_time: formt_time_start, end_time: formt_time_end, working_fee: total_fee)
    respond_to do |format|
      if @time_sheet.save
        format.html { redirect_to time_sheets_path, notice: "Time sheet was successfully created." }
        format.json { render :show, status: :created, location: @time_sheet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @time_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  def detect_working_time(start_time, end_time, group)
    default_st_time = TIME[group.to_sym][:start_time]
    default_end_time = TIME[group.to_sym][:end_time]
    ot_before_start_time = default_st_time > start_time ? default_st_time.to_f - start_time.to_f : 0
    ot_after_end_time = default_end_time < end_time ? end_time.to_f - default_end_time.to_f : 0
    
    {
      normal_time: end_time - start_time - ot_before_start_time - ot_after_end_time,
      ot_time: ot_before_start_time + ot_after_end_time
    }
  end

  def calculate_fee(working_time, group)
    normal_fee = FEE[group.to_sym]
    ot_fee = OT_FEE[group.to_sym]
    normal_fee = working_time[:normal_time] * normal_fee
    ot_paid = working_time[:ot_time] * ot_fee

    normal_fee + ot_paid
  end

  def change_time_format(hour, minute)
    format_minute = 0
    if minute != 0
      format_minute = (minute/60).round(2)
    end

    hour + format_minute
  end

  private

  def time_sheet_params
    params.require(:time_sheet).permit(:working_date, :start_time, :end_time)
  end
end