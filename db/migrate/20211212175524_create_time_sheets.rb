class CreateTimeSheets < ActiveRecord::Migration[6.1]
  def change
    create_table :time_sheets do |t|
      t.date :working_date
      t.time :start_time
      t.time :end_time
      t.float :working_fee

      t.timestamps
    end
  end
end
