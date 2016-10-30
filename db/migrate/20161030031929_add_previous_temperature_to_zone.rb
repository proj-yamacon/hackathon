class AddPreviousTemperatureToZone < ActiveRecord::Migration
  def change
    add_column :zones, :previous_temperature, :float
    add_column :zones, :previous_temperature_update, :timestamp
  end
end
