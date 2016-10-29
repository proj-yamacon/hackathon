class CreateZones < ActiveRecord::Migration
  def change
    create_table :zones do |t|
      t.string :zone_name
      t.float :target_temperature
      t.float :current_temperature

      t.timestamps null: false
    end
  end
end
